{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchurl,
}:

python3Packages.buildPythonApplication rec {
  pname = "tuna-profiler";
  version = "0.5.11";

  src = fetchFromGitHub {
    owner = "nschloe";
    repo = "tuna";
    tag = "v${version}";
    hash = "sha256-ugtKa5kN1WzvCtLz/cTr0MnNBMzM7sHWQrfokwHFtCk=";
  };

  bootstrap-css = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css";
    hash = "sha256-YvdLHPgkqJ8DVUxjjnGVlMMJtNimJ6dYkowFFvp4kKs=";
  };

  d3-js = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/d3@7/dist/d3.min.js";
    hash = "sha256-8glLv2FBs1lyLE/kVOtsSw8OQswQzHr5IfwVj864ZTk=";
  };

  postPatch = ''
    mkdir -p tuna/web/static/
    ln -s ${bootstrap-css} tuna/web/static/bootstrap.min.css
    ln -s ${d3-js} tuna/web/static/d3.min.js
  '';

  build-system = [
    python3Packages.setuptools
  ];

  pyproject = true;

  # This preCheck makes tests run successfully by adding
  # tuna to the PATH
  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
  ];

  pythonImportsCheck = [ "tuna" ];

  meta = {
    description = "Visualize Python profile data";
    homepage = "https://github.com/nschloe/tuna";
    mainProgram = "tuna";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ b-rodrigues ];
  };
}
