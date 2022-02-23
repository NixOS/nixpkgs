{ lib, stdenv, fetchFromGitHub, glfw, freetype, openssl, makeWrapper, upx }:

stdenv.mkDerivation rec {
  pname = "vlang";
  version = "weekly.2022.07";

  src = fetchFromGitHub {
    owner = "vlang";
    repo = "v";
    rev = version;
    sha256 = "sTnev6nxmaR8aSZJ9K70iZF84WkkoxOrbza9a+MTwxY=";
  };

  vc = fetchFromGitHub {
    owner = "vlang";
    repo = "vc";
    rev = "3155be181911eb94ada67fcfef0911df7017992c";
    sha256 = "SXf4F0c4aNSL+6Dze6W8cFSqJZr361gDNAjxPjduuHw=";
  };

  # Require for pre-building v tools
  markdown_module = fetchFromGitHub {
    name = "vmarkdown_module";
    owner = "vlang";
    repo = "markdown";
    rev = "8d90d75bf1985fd73a101cba653adf04b14e1825";
    sha256 = "SsK82AAr2qvGsK13GfCi4qvTAvUSKR7N0pLnNAH/OWU=";
  };

  propagatedBuildInputs = [ glfw freetype openssl ]
    ++ lib.optional stdenv.hostPlatform.isUnix upx;

  nativeBuildInputs = [ makeWrapper ];

  makeFlags = [
    "local=1"
    "VC=${vc}"
    # vlang seems to want to write to $HOME/.vmodules , so lets give
    # it a writable HOME
    "HOME=$TMPDIR"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,lib,share}
    cp -r examples $out/share
    cp -r {cmd,vlib,thirdparty} $out/lib
    mv v $out/lib
    ln -s $out/lib/v $out/bin/v
    wrapProgram $out/bin/v --prefix PATH : ${lib.makeBinPath [ stdenv.cc ]}

    # This is require to because after installation, v will have no write
    # access and v tools requires installation.
    # should have done with `$out/lib/v build-tools` but this too requires git.
    export HOME=$out
    # Require for vdoc
    mkdir -p $out/.vmodules; cp -r ${markdown_module}/ $out/.vmodules/markdown

    ARG="-v"
    $out/lib/v $ARG $out/lib/cmd/tools/vfmt.v
    $out/lib/v $ARG $out/lib/cmd/tools/vpm.v
    $out/lib/v $ARG $out/lib/cmd/tools/vcreate.v
    $out/lib/v $ARG $out/lib/cmd/tools/vtest.v
    $out/lib/v $ARG $out/lib/cmd/tools/vrepl.v
    $out/lib/v $ARG $out/lib/cmd/tools/missdoc.v
    $out/lib/v $ARG $out/lib/cmd/tools/vbin2v.v
    $out/lib/v $ARG $out/lib/cmd/tools/vbug.v
    $out/lib/v $ARG $out/lib/cmd/tools/vcomplete.v
    $out/lib/v $ARG $out/lib/cmd/tools/vwipe-cache.v
    $out/lib/v $ARG $out/lib/cmd/tools/vdoc
    $out/lib/v $ARG $out/lib/cmd/tools/vvet
    $out/lib/v $ARG $out/lib/cmd/tools/vast
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://vlang.io/";
    description =
      "Simple, fast, safe, compiled language for developing maintainable software";
    license = licenses.mit;
    maintainers = with maintainers; [ chiiruno ];
    platforms = platforms.all;
  };
}
