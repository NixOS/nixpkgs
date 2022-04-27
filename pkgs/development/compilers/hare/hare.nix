{ binutils-unwrapped, fetchFromSourcehut, git, harec, lib, makeWrapper, openssh
, qbe, scdoc, stdenv, }:

stdenv.mkDerivation rec {
  pname = "hare";
  version = "unstable-2022-04-28";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = pname;
    rev = "340e7867667a533abb173582f40016e544369e71";
    sha256 = "19aaj6z69qz8mlfdar7gjnbrgf2ja9ckmhjnhp5nl17c73ddfpfd";
  };

  preConfigure = ''
    cp config.example.mk config.mk
  '';
  makeFlags = [ "PREFIX=$(out)" "LOCALSRCDIR=$(out)/local/src/hare" ];

  # Default cache location is user home, not writeable at Nix build time.
  preBuild = ''
    export HARECACHE="$NIX_BUILD_TOP"
  '';
  strictDeps = true;
  buildInputs = [ makeWrapper ];
  nativeBuildInputs = [ harec scdoc qbe ];

  doCheck = true;

  # Git and OpenSSH could be made optional, only needed for `hare release`.
  postInstall = ''
    wrapProgram $out/bin/hare --prefix PATH : ${
      lib.makeBinPath [ binutils-unwrapped git harec openssh qbe ]
    }
  '';

  meta = with lib; {
    homepage = "https://harelang.org";
    description =
      "Systems programming language designed to be simple, stable, and robust";
    maintainers = with maintainers; [ ninjin ];
    # Compiler is gpl3Only and standard library mpl20
    license = with licenses; [ gpl3Only mpl20 ];
    # Linux aarch64 and riscv64 supported too, but maintainer unable to support.
    platforms = [ "x86_64-linux" ];
  };
}
