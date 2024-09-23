{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  runCommand,
  writeText,
  uglify-js,
}:

buildNpmPackage rec {
  pname = "uglify-js";
  version = "3.18.0";

  src = fetchFromGitHub {
    owner = "mishoo";
    repo = "UglifyJS";
    rev = "v${version}";
    hash = "sha256-m+OEcvWEk4RX0C4re9TFZpkcBvSwl7qfIM+56t100ws=";
  };

  npmDepsHash = "sha256-iLWmNifHpVvFSFXkfItVpGlh6za9T9wSr1Af4CQQSGM=";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  passthru = {
    updateScript = ./update.sh;
    tests = {
      version = testers.testVersion { package = uglify-js; };

      simple = testers.testEqualContents {
        assertion = "uglify-js minifies a basic js file";
        expected = writeText "expected" ''
          console.log(1);
        '';
        actual =
          runCommand "actual"
            {
              nativeBuildInputs = [ uglify-js ];
              base = writeText "base" ''
                console . log  ( ( 1 ) ) ;
              '';
            }
            ''
              uglifyjs $base > $out
            '';
      };
    };
  };

  meta = {
    homepage = "https://github.com/mishoo/UglifyJS";
    description = "JavaScript parser / mangler / compressor / beautifier toolkit";
    mainProgram = "uglifyjs";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ lelgenio ];
  };
}
