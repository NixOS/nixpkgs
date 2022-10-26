{ lib, stdenv, fetchFromGitHub, glfw, freetype, openssl, makeWrapper, upx }:

stdenv.mkDerivation rec {
  pname = "vlang";
  version = "weekly.2022.43";

  src = fetchFromGitHub {
    owner = "vlang";
    repo = "v";
    rev = version;
    sha256 = "16pga2ww5sq93ld410yf4kmc8v5pmfg1g46qb71j1r7iw6avdz3w";
  };

  # Required for bootstrap.
  vc = fetchFromGitHub {
    owner = "vlang";
    repo = "vc";
    rev = "2510de8ca11c798a5c5599dd7f35ce34cf2df8ae";
    sha256 = "0bqrkjbiv3pii3axp70pr48y0prwv80lwzc8ffp74n2i18yzckki";
  };

  # Required for vdoc.
  markdown = fetchFromGitHub {
    owner = "vlang";
    repo = "markdown";
    rev = "014724a2e35c0a7e46ea9cc91f5a303f2581b62c";
    sha256 = "08gl20f0a4bbxf9gr1nqbcmhphcqzmv8c45l587h8dkkm2dzghlf";
  };

  propagatedBuildInputs = [ glfw freetype openssl ]
    ++ lib.optional stdenv.hostPlatform.isUnix upx;

  nativeBuildInputs = [ makeWrapper ];

  makeFlags = [
    "local=1"
    "VC=${vc}"
  ];

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  # vcreate_test.v requires git, so we must remove it when building the tools.
  # vtest.v fails on Darwin, so let's just disable it for now.
  preInstall = ''
    mv cmd/tools/vcreate_test.v $HOME/vcreate_test.v
  '' + lib.optionalString stdenv.isDarwin ''
    mv cmd/tools/vtest.v $HOME/vtest.v
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib,share}
    cp -r examples $out/share
    cp -r {cmd,vlib,thirdparty} $out/lib
    cp v $out/lib
    ln -s $out/lib/v $out/bin/v
    wrapProgram $out/bin/v --prefix PATH : ${lib.makeBinPath [ stdenv.cc ]}

    mkdir -p $HOME/.vmodules;
    ln -sf ${markdown} $HOME/.vmodules/markdown
    $out/lib/v -v build-tools
    $out/lib/v -v $out/lib/cmd/tools/vdoc
    $out/lib/v -v $out/lib/cmd/tools/vast
    $out/lib/v -v $out/lib/cmd/tools/vvet

    runHook postInstall
  '';

  # Return vcreate_test.v and vtest.v, so the user can use it.
  postInstall = ''
    cp $HOME/vcreate_test.v $out/lib/cmd/tools/vcreate_test.v
  '' + lib.optionalString stdenv.isDarwin ''
    cp $HOME/vtest.v $out/lib/cmd/tools/vtest.v
  '';

  meta = with lib; {
    homepage = "https://vlang.io/";
    description = "Simple, fast, safe, compiled language for developing maintainable software";
    license = licenses.mit;
    maintainers = with maintainers; [ Madouura ];
    mainProgram = "v";
    platforms = platforms.all;
  };
}
