{ stdenv, fetchFromGitHub, makeWrapper
, clang, chez
}:

# Uses scheme to bootstrap the build of idris2
stdenv.mkDerivation {
  name = "idris2";
  version = "0.2.0-840e020";

  src = fetchFromGitHub {
    owner = "idris-lang";
    repo = "Idris2";
    rev = "840e020d8ccc332135e86f855ad78053ca15d603";
    sha256 = "1l6pdjiglwd13pf56xwzbjzyyxgz48ypfggjgsgqk2w57rmbfy90";
  };

  strictDeps = true;
  nativeBuildInputs = [ makeWrapper clang chez ];
  buildInputs = [ chez ];

  prePatch = ''
    patchShebangs --build tests

    # Do not run tests as part of the build process
    substituteInPlace bootstrap.sh --replace "make test" "# make test"
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  # The name of the main executable of pkgs.chez is `scheme`
  buildFlags = [ "bootstrap" "SCHEME=scheme" ];

  # idris2 needs to find scheme at runtime to compile
  postInstall = ''
    wrapProgram "$out/bin/idris2" --prefix PATH : "${chez}/bin"
  '';

  meta = {
    description = "A purely functional programming language with first class types";
    homepage = https://github.com/idris-lang/Idris2;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ wchresta ];
  };
}

