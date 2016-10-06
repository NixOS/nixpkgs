{stdenv, fetchurl, ocaml, libgcrypt, fetchFromGitHub, ocamlPackages, perl}:
stdenv.mkDerivation rec {
  name = "obliv-c-${version}";
  version = "0.0pre20161001";
  buildInputs = [ ocaml ocamlPackages.findlib perl ];
  propagatedBuildInputs = [ libgcrypt ];
  src = fetchFromGitHub {
    owner = "samee";
    repo = "obliv-c";
    rev = "32d71fb46983aded604045e8cda7874d8fb160a2";
    sha256 = "05bicvalsfabngvf41q02bcyzkibmyihj7naqd53kdq75xa1yf37";
  };
  preInstall = ''
    mkdir -p "$out/bin"
    cp bin/* "$out/bin"
    mkdir -p "$out/share/doc/obliv-c"
    cp -r doc/* README* CHANGE* Change* LICEN* TODO* "$out/share/doc/obliv-c"
    mkdir -p "$out/share/obliv-c"
    cp -r test "$out/share/obliv-c"
    mkdir -p "$out/include"
    cp src/ext/oblivc/*.h "$out/include"
    mkdir -p "$out/lib"
    gcc $(ar t _build/libobliv.a | sed -e 's@^@_build/@') --shared -o _build/libobliv.so
    cp _build/lib*.a _build/lib*.so* "$out/lib"
  '';
  meta = {
    inherit version;
    description = ''A GCC wrapper that makes it easy to embed secure computation protocols inside regular C programs'';
    license = stdenv.lib.licenses.bsd3;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
