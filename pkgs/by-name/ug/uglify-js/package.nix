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
  version = "3.19.3";

  src = fetchFromGitHub {
    owner = "mishoo";
    repo = "UglifyJS";
    rev = "v${version}";
    hash = "sha256-sMLQSB1+ux/ya/J22KGojlAxWhtPQdk22KdHy43zdyg=";
  };

  npmDepsHash = "sha256-/Xb8DT7vSzZPEd+Z+z1BlFnrOeOwGP+nGv2K9iz6lKI=";

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
    changelog = "https://github.com/mishoo/UglifyJS/releases/tag/v" + version;
    description = "JavaScript parser / mangler / compressor / beautifier toolkit";
    mainProgram = "uglifyjs";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ lelgenio ];
  };
}
