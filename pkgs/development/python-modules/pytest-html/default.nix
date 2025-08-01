{
  lib,
  buildNpmPackage,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  hatch-vcs,
  hatchling,
  jinja2,
  pytest,
  pytest-metadata,
}:
let
  pname = "pytest-html";
  version = "4.1.1";

  src = fetchPypi {
    pname = "pytest_html";
    inherit version;
    hash = "sha256-cKAeiuWAD0oHS1akyxAlyPT5sDi7pf4x48mOuZZobwc=";
  };

  web-assets = buildNpmPackage {
    pname = "${pname}-web-assets";
    inherit version src;

    npmDepsHash = "sha256-aRod+SzVSb4bqEJzthfl/mH+DpbIe+j2+dNtrrhO2xU=";

    installPhase = ''
      runHook preInstall

      install -Dm644 src/pytest_html/resources/{app.js,style.css} -t $out/lib

      runHook postInstall
    '';
  };
in

buildPythonPackage {
  inherit pname version src;
  format = "pyproject";

  disabled = pythonOlder "3.6";

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];
  buildInputs = [
    pytest
    web-assets
  ];
  propagatedBuildInputs = [
    jinja2
    pytest-metadata
  ];

  env.HATCH_BUILD_NO_HOOKS = true;

  preBuild = ''
    install -Dm644 ${web-assets}/lib/{app.js,style.css} -t src/pytest_html/resources
  '';

  # tests require network access
  doCheck = false;

  pythonImportsCheck = [ "pytest_html" ];

  meta = with lib; {
    description = "Plugin for generating HTML reports";
    homepage = "https://github.com/pytest-dev/pytest-html";
    license = licenses.mpl20;
    maintainers = with maintainers; [ mpoquet ];
  };
}
