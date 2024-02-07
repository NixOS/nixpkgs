{ lib
, buildNpmPackage
, fetchFromGitHub
, testers
, runCommand
, writeText
, uglify-js
}:

buildNpmPackage rec {
  pname = "uglify-js";
  version = "3.17.4";

  src = fetchFromGitHub {
    owner = "mishoo";
    repo = "UglifyJS";
    rev = "v${version}";
    hash = "sha256-85ZpLSpKOWwNG9F2tQ6j2otOOCOAyuRUy9AYdpr9eFo=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-8QNjjP/QlXs5oyr7MXouLAqGKuSjkV3KIe50mn6s3No=";

  dontNpmBuild = true;

  passthru = {
    updateScript = ./update.sh;
    tests = {
      version = testers.testVersion {
        package = uglify-js;
        command = "uglifyjs --version";
      };

      simple = testers.testEqualContents {
        assertion = "uglify-js minifies a basic js file";
        expected = writeText "expected" ''
          console.log(1);
        '';
        actual = runCommand "actual"
          {
            nativeBuildInputs = [ uglify-js ];
            base = writeText "base" ''
              console . log  ( ( 1 ) ) ;
            '';
          } ''
          uglifyjs $base > $out
        '';
      };
    };
  };

  meta = with lib; {
    homepage = "https://github.com/mishoo/UglifyJS";
    description = "JavaScript parser / mangler / compressor / beautifier toolkit";
    mainProgram = "uglifyjs";
    license = licenses.bsd2;
    maintainers = with maintainers; [ lelgenio ];
  };
}
