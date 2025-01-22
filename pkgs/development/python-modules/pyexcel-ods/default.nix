{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  pyexcel-io,
  odfpy,
  pyexcel,
  pyexcel-xls,
  psutil,
  pytestCheckHook,
  pytest-cov-stub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyexcel-ods";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyexcel";
    repo = "pyexcel-ods";
    rev = "v${version}";
    hash = "sha256-wptjCSi56hotmiIE0TrLY7jsCHKwDR+a7d89sAQWBHg=";
  };

  patches = [
    # https://github.com/pyexcel/pyexcel-ods/pull/45
    (fetchpatch2 {
      name = "nose-to-pytest.patch";
      url = "https://github.com/pyexcel/pyexcel-ods/compare/661d4f0b484ed281128c72e1a2701e2d33fc1879...838b410e800a86c147644568aaa8b2c005d13491.patch";
      hash = "sha256-1a52VM8yGDEjSFXTq3Di74xwv10d/QskpctOnz9zW1w=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    pyexcel-io
    odfpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pyexcel
    pyexcel-xls
    psutil
  ];

  meta = {
    description = "Plug-in to pyexcel providing the capbility to read, manipulate and write data in ods formats using odfpy";
    homepage = "http://docs.pyexcel.org/";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
