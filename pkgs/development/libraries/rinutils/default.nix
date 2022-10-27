{
  stdenv, lib, fetchurl,
  cmake, perl,
}:

stdenv.mkDerivation rec {
  pname = "rinutils";
  version = "0.10.1";

  meta = with lib; {
    homepage = "https://github.com/shlomif/rinutils";
    license = licenses.mit;
  };

  src = fetchurl {
    url = "https://github.com/shlomif/${pname}/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-MewljOmd57u+efMzjOcwSNrEVCUEXrK9DWvZLRuLmvs=";
  };

  nativeBuildInputs = [ cmake perl ];

  # https://github.com/shlomif/rinutils/issues/5
  # (variable was unused at time of writing)
  postPatch = ''
    substituteInPlace librinutils.pc.in \
      --replace '$'{exec_prefix}/@RINUTILS_INSTALL_MYLIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@
  '';
}
