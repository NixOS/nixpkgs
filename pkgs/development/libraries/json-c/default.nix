{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake }:

stdenv.mkDerivation rec {
  pname = "json-c";
  version = "0.16";

  src = fetchFromGitHub {
    owner = "json-c";
    repo = "json-c";
    rev = "json-c-0.16-20220414";
    sha256 = "sha256-KbnUWLgpg6/1wvXhUoYswyqDcgiwEcvgaWCPjNcX20o=";
  };

  patches = [
    # needed for emscripten, which uses LLVM 15+
    (fetchpatch {
      url = "https://github.com/json-c/json-c/commit/6eca65617aacd19f4928acd5766b8dd20eda0b34.patch";
      sha256 = "sha256-fyugX+HgYlt/4AVtfNDaKS+blyUt8JYTNqkmhURb9dk=";
    })
  ];

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "A JSON implementation in C";
    longDescription = ''
      JSON-C implements a reference counting object model that allows you to
      easily construct JSON objects in C, output them as JSON formatted strings
      and parse JSON formatted strings back into the C representation of JSON
      objects.
    '';
    homepage    = "https://github.com/json-c/json-c/wiki";
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
    license = licenses.mit;
  };
}
