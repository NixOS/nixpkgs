{ stdenvNoCC, writeText, fetchurl, rpm, cpio, openmp }:

stdenvNoCC.mkDerivation rec {
  name = "mkl-${version}";
  version = "${date}.${rel}";
  date = "2019.0";
  rel = "117";

  src = fetchurl {
    url = "http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/13575/l_mkl_${version}.tgz";
    sha256 = "1bf7i54iqlf7x7fn8kqwmi06g30sxr6nq3ac0r871i6g0p3y47sf";
  };

  buildInputs = [ rpm cpio ];
  propagatedBuildInputs = [ openmp ];

  buildPhase = ''
    rpm2cpio rpm/intel-mkl-common-c-${date}-${rel}-${date}-${rel}.noarch.rpm | cpio -idmv
    rpm2cpio rpm/intel-mkl-core-rt-${date}-${rel}-${date}-${rel}.x86_64.rpm | cpio -idmv
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp -r opt/intel/compilers_and_libraries_${version}/linux/mkl/include $out/
    cp -r opt/intel/compilers_and_libraries_${version}/linux/mkl/lib/intel64_lin/* $out/lib/
    cp license.txt $out/lib/
  '';

  # Per license agreement, do not modify the binary
  dontStrip = true;
  dontPatchELF = true;

  # Some mkl calls require openmp, but Intel does not add these to SO_NEEDED and
  # instructs users to put openmp on their LD_LIBRARY_PATH.
  setupHook = writeText "setup-hook.sh" ''
    addOpenmp() {
        addToSearchPath LD_LIBRARY_PATH ${openmp}/lib
    }
    addEnvHooks "$targetOffset" addOpenmp
  '';

  meta = with stdenvNoCC.lib; {
    description = "Intel Math Kernel Library";
    longDescription = ''
      Intel Math Kernel Library (Intel MKL) optimizes code with minimal effort
      for future generations of Intel processors. It is compatible with your
      choice of compilers, languages, operating systems, and linking and
      threading models.
    '';
    homepage = https://software.intel.com/en-us/mkl;
    license = licenses.issl;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.bhipple ];
  };
}
