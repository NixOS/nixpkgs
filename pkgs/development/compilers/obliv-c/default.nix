{ lib, stdenv, libgcrypt, fetchFromGitHub, ocamlPackages, perl }:
stdenv.mkDerivation rec {
  pname = "obliv-c";
  version = "0.0pre20210621";
  buildInputs = [ perl ]
  ++ (with ocamlPackages; [ ocaml findlib ocamlbuild ]);
  propagatedBuildInputs = [ libgcrypt ];
  src = fetchFromGitHub {
    owner = "samee";
    repo = "obliv-c";
    rev = "e02e5c590523ef4dae06e167a7fa00037bb3fdaf";
    sha256 = "sha256:02vyr4689f4dmwqqs0q1mrack9h3g8jz3pj8zqiz987dk0r5mz7a";
  };

  hardeningDisable = [ "fortify" ];

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
    description = "A GCC wrapper that makes it easy to embed secure computation protocols inside regular C programs";
    license = lib.licenses.bsd3;
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.linux;
  };
}
