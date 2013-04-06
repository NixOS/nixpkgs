{ fetchurl, stdenv, makeWrapper, perl, mesa, xorg }:

# TODO: Add support for x86
assert stdenv.system == "x86_64-linux";

stdenv.mkDerivation rec {
  version = "2.8";
  name = "amdapp-sdk-${version}";

  src = fetchurl {
    url = "http://developer.amd.com/wordpress/media/2012/11/AMD-APP-SDK-v${version}-lnx64.tgz";
    sha256 = "d9c120367225bb1cd21abbcf77cb0a69cfb4bb6932d0572990104c566aab9681";
  };

  # TODO: Add optional aparapi support
  patches = [ ./01-remove-aparapi-samples.patch ];

  patchFlags = "-p0";
  buildInputs = [ makeWrapper perl mesa xorg.libX11 xorg.libXext xorg.libXaw xorg.libXi ];
  NIX_LDFLAGS = "-lX11 -lXext -lXmu -lXi";
  doCheck = false;

  unpackPhase = ''
    tar xvzf $src
    tar xf AMD-APP-SDK-v${version}-RC-lnx64.tgz
    cd AMD-APP-SDK-v${version}-RC-lnx64
  '';

  installPhase = ''
    #Install SDK
    mkdir -p $out
    cp -r {docs,include} "$out/"
    mkdir -p "$out/"{bin,lib,samples/opencl/bin}
    cp -r "./bin/x86_64/clinfo" "$out/bin/clinfo"
    cp -r "./lib/x86_64/"* "$out/lib/"
    find ./samples/opencl/ -mindepth 1 -maxdepth 1 -type d -not -name bin -exec cp -r {} "$out/samples/opencl" \;
    cp -r "./samples/opencl/bin/x86_64/"* "$out/samples/opencl/bin"

    #Register ICD
    mkdir -p "$out/etc/OpenCL/vendors"
    echo "$out/lib/libamdocl64.so" > "$out/etc/OpenCL/vendors/amd.icd"
    # The OpenCL ICD specifications: http://www.khronos.org/registry/cl/extensions/khr/cl_khr_icd.txt

    #Install includes
    mkdir -p "$out/usr/include/"{CAL,OpenVideo}
    install -m644 './include/OpenVideo/'{OVDecode.h,OVDecodeTypes.h} "$out/usr/include/OpenVideo/"

    #Create wrappers
    wrapProgram "$out/bin/clinfo" --prefix LD_LIBRARY_PATH ":" "$out/lib"

    #Fix modes
    find "$out/" -type f -exec chmod 644 {} \;
    chmod -R 755 "$out/bin/"
    find "$out/samples/opencl/bin" -type f -not -name "*.*" -exec chmod 755 {} \;
  '';

  meta = {
    description = "AMD Accelerated Parallel Processing (APP) SDK, with OpenCL 1.2 support";
    homepage = http://developer.amd.com/tools/heterogeneous-computing/amd-accelerated-parallel-processing-app-sdk/;
    license = "unfree";
    platforms = [ "x86_64-linux" ];
  };
}
