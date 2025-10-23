{
  lib,
  buildDunePackage,
  fetchurl,
  fetchpatch,
  cppo,
  uutf,
  lwt,
}:

buildDunePackage rec {
  version = "0.2.3";
  pname = "notty";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/pqwy/notty/releases/download/v${version}/notty-${version}.tbz";
    sha256 = "sha256-dGWfsUBz20Q4mJiRqyTyS++Bqkl9rBbZpn+aHJwgCCQ=";
  };

  # Compatibility with OCaml 5.4
  patches = fetchpatch {
    url = "https://github.com/pqwy/notty/commit/a4d62f467e257196a5192da2184bd021dfd948b7.patch";
    hash = "sha256-p1eUuCvQKLj8uBeGyT2+i9WOYy4rk84pf9L3QioJDNY=";
  };

  nativeBuildInputs = [ cppo ];

  propagatedBuildInputs = [
    lwt
    uutf
  ];

  meta = with lib; {
    homepage = "https://github.com/pqwy/notty";
    description = "Declarative terminal graphics for OCaml";
    license = licenses.isc;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
