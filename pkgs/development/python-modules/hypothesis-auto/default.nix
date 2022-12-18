{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, hypothesis
, poetry-core
, pydantic
, pytest
, pythonOlder
}:

buildPythonPackage rec {
  pname = "hypothesis-auto";
  version = "1.1.4";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XiwvsJ3AmEJRLYBjC7eSNZodM9LARzrUfuI9oL6eMrE=";
  };

  patches = [
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/timothycrosley/hypothesis-auto/commit/8277b4232617c0433f80e9c2844452b9fae67a65.patch";
      hash = "sha256-/0z0nphtQnUBiLYhhzLZT59kQgktSugaBg+ePNxy0qI=";
    })
  ];

  postPatch = ''
    # https://github.com/timothycrosley/hypothesis-auto/pull/20
    substituteInPlace pyproject.toml \
      --replace 'pydantic = ">=0.32.2<2.0.0"' 'pydantic = ">=0.32.2, <2.0.0"' \
      --replace 'hypothesis = ">=4.36<6.0.0"' 'hypothesis = "*"'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pydantic
    hypothesis
    pytest
  ];

  pythonImportsCheck = [
    "hypothesis_auto"
  ];

  meta = with lib; {
    description = "Enables fully automatic tests for type annotated functions";
    homepage = "https://github.com/timothycrosley/hypothesis-auto/";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
