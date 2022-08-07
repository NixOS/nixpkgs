{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, bison
, binutils
, binutils-unwrapped
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "myrddin";
  version = "0.3.1";

  src = fetchFromGitHub {
    repo = "mc";
    owner = "oridb";
    rev = "r${version}";
    sha256 = "7ImjiG/rIKGPHq3Vh/mftY7pqw/vfOxD3LJeT87HmCk=";
  };

  nativeBuildInputs = [
    bison
    pkg-config
    makeWrapper
  ];

  postPatch = ''
    substituteInPlace mk/c.mk \
        --replace "-Werror" ""
  '';

  buildPhase = ''
    make bootstrap
    make
  '';

  postInstall = ''
    for b in $out/bin/*; do
        wrapProgram $b --prefix PATH : $out/bin:${lib.makeBinPath [ binutils ]}
    done
  '';

  checkPhase = ''
    make check
  '';

  doCheck = true;

  meta = with lib; {
    # darwin: never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/myrddin.x86_64-darwin
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "Systems language that is both powerful and fun to use";
    homepage = "https://myrlang.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.all;
  };
}
