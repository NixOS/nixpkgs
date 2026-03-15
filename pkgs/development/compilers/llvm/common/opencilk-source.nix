{
  fetchFromGitHub,
  runCommand,
}:

let
  version = "v3.0";

  opencilkProject = fetchFromGitHub {
    owner = "OpenCilk";
    repo = "opencilk-project";
    rev = "opencilk/${version}";
    hash = "sha256-QIBpCsdDVbXh35VGVDymI9CvAnTo1SA0UxZvJ0LUy0k=";
  };

  cheetah = fetchFromGitHub {
    owner = "OpenCilk";
    repo = "cheetah";
    rev = "opencilk/${version}";
    hash = "sha256-qBjYuCqw7Dk3IFrf9nEkGMjdveev2WiX9zSDHoSpnDc=";
  };

  productivityTools = fetchFromGitHub {
    owner = "OpenCilk";
    repo = "productivity-tools";
    rev = "opencilk/${version}";
    hash = "sha256-E59xva3+TFo7VCUO7/qVgHr0ZSiZq1cByRzCVfrQlP8=";
  };

in
runCommand "opencilk-source-${version}" { } ''
  mkdir -p $out
  cp -r ${opencilkProject}/* $out/
  chmod -R u+w $out

  rm -rf $out/cheetah $out/cilktools
  cp -r ${cheetah} $out/cheetah
  cp -r ${productivityTools} $out/cilktools
''
