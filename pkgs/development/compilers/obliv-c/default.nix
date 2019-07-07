{ stdenv, libgcrypt, fetchFromGitHub, ocamlPackages, perl }:
stdenv.mkDerivation rec {
  name = "obliv-c-${version}";
  version = "0.0pre20180624";
  buildInputs = [ perl ]
  ++ (with ocamlPackages; [ ocaml findlib ocamlbuild ]);
  propagatedBuildInputs = [ libgcrypt ];
  src = fetchFromGitHub {
    owner = "samee";
    repo = "obliv-c";
    rev = "3d6804ca0fd85868207a0ccbd2509ec064723ac2";
    sha256 = "1ib21ngn7zr58xxq4sjigrpaxb0wx35x3k9l4qvwflzrmvnman20";
  };

  patches = [ ./ignore-complex-float128.patch ];

  preBuild = ''
    patchShebangs .
  '';

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
