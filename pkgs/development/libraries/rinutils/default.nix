{ stdenv
, lib
, fetchurl
, cmake
, perl
}:

stdenv.mkDerivation rec {
  pname = "rinutils";
  version = "0.10.3";

  src = fetchurl {
    url = "https://github.com/shlomif/${pname}/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-+eUn03psyMe4hwraY8qiTzKrDSn9ERbfPrtoZYMDCVU=";
  };

  nativeBuildInputs = [ cmake perl ];

  meta = with lib; {
    description = "C11 / gnu11 utilities C library by Shlomi Fish / Rindolf";
    homepage = "https://github.com/shlomif/rinutils";
    changelog = "https://github.com/shlomif/rinutils/raw/${version}/NEWS.asciidoc";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
