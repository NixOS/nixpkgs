{ stdenv, fetchurl, makeWrapper, perl, libGLU_combined, xorg,
  version? "2.8", # What version
  samples? false # Should samples be installed
}:

let

  bits = if stdenv.system == "x86_64-linux" then "64"
         else "32";

  arch = if stdenv.system == "x86_64-linux" then "x86_64"
         else "x86";

  src_info = {
    "2.6" = {
      url = "http://download2-developer.amd.com/amd/APPSDK/AMD-APP-SDK-v2.6-lnx${bits}.tgz";
      x86 = "03vyvqp44f96036zsyy8n21ymbzy2bx09hlbd6ci3ikj8g7ic1dm";
      x86_64 = "1fj55358s4blxq9bp77k07gqi22n5nfkzwjkbdc62gmy1zxxlhih";
   };

    "2.7" = {
      url = "http://download2-developer.amd.com/amd/APPSDK/AMD-APP-SDK-v2.7-lnx${bits}.tgz";
      x86 = "1v26n7g1xvlg5ralbfk3qiy34gj8fascpnjzm3120b6sgykfp16b";
      x86_64 = "08bi43bgnsxb47vbirh09qy02w7zxymqlqr8iikk9aavfxjlmch1";
      patches = [ ./gcc-5.patch];
    };

    "2.8" = {
      url = "http://developer.amd.com/wordpress/media/2012/11/AMD-APP-SDK-v2.8-lnx${bits}.tgz";
      x86 = "99610737f21b2f035e0eac4c9e776446cc4378a614c7667de03a82904ab2d356";
      x86_64 = "d9c120367225bb1cd21abbcf77cb0a69cfb4bb6932d0572990104c566aab9681";

      # TODO: Add support for aparapi, java parallel api
      patches = [ ./01-remove-aparapi-samples.patch ./gcc-5.patch];
    };
  };

in stdenv.mkDerivation rec {
  name = "amdapp-sdk-${version}";

  src = fetchurl {
    url = stdenv.lib.getAttrFromPath [version "url"] src_info;
    sha256 = stdenv.lib.getAttrFromPath [version arch] src_info;
  };

  patches = stdenv.lib.attrByPath [version "patches"] [] src_info;

  patchFlags = "-p0";
  buildInputs = [ makeWrapper perl libGLU_combined xorg.libX11 xorg.libXext xorg.libXaw xorg.libXi xorg.libXxf86vm ];
  propagatedBuildInputs = [ stdenv.cc ];
  NIX_LDFLAGS = "-lX11 -lXext -lXmu -lXi -lXxf86vm";
  doCheck = false;

  unpackPhase = ''
    tar xvzf $src
    tar xf AMD-APP-SDK-v${version}-*-lnx${bits}.tgz
    cd AMD-APP-SDK-v${version}-*-lnx${bits}
  '';

  buildPhase = if !samples then ''echo "nothing to build"'' else null;

  installPhase = ''
    # Install SDK
    mkdir -p $out
    cp -r {docs,include} "$out/"
    mkdir -p "$out/"{bin,lib,samples/opencl/bin}
    cp -r "./bin/${arch}/clinfo" "$out/bin/clinfo"
    cp -r "./lib/${arch}/"* "$out/lib/"

    # Register ICD
    mkdir -p "$out/etc/OpenCL/vendors"
    echo "$out/lib/libamdocl${bits}.so" > "$out/etc/OpenCL/vendors/amd.icd"
    # The OpenCL ICD specifications: http://www.khronos.org/registry/cl/extensions/khr/cl_khr_icd.txt

    # Install includes
    mkdir -p "$out/usr/include/"{CAL,OpenVideo}
    install -m644 './include/OpenVideo/'{OVDecode.h,OVDecodeTypes.h} "$out/usr/include/OpenVideo/"

    ${ if samples then ''
      # Install samples
      find ./samples/opencl/ -mindepth 1 -maxdepth 1 -type d -not -name bin -exec cp -r {} "$out/samples/opencl" \;
      cp -r "./samples/opencl/bin/${arch}/"* "$out/samples/opencl/bin"
      for f in $(find "$out/samples/opencl/bin/" -type f -not -name "*.*");
      do
        wrapProgram "$f" --prefix PATH ":" "${stdenv.cc}/bin"
      done'' else ""
    }

    # Create wrappers
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/bin/clinfo
    patchelf --set-rpath ${stdenv.cc.cc.lib}/lib64:${stdenv.cc.cc.lib}/lib $out/bin/clinfo

    # Fix modes
    find "$out/" -type f -exec chmod 644 {} \;
    chmod -R 755 "$out/bin/"
    find "$out/samples/opencl/bin/" -type f -name ".*" -exec chmod 755 {} \;
    find "$out/samples/opencl/bin/" -type f -not -name "*.*" -exec chmod 755 {} \;
  '';

  meta = with stdenv.lib; {
    description = "AMD Accelerated Parallel Processing (APP) SDK, with OpenCL 1.2 support";
    homepage = https://developer.amd.com/amd-accelerated-parallel-processing-app-sdk/;
    license = licenses.amd;
    maintainers = [ maintainers.offline ];
    platforms = [ "i686-linux" "x86_64-linux" ];
 };
}
