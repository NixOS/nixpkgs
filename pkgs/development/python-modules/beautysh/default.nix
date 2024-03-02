{ lib
, buildPythonPackage
, colorama
, fetchFromGitHub
, fetchpatch
, poetry-core
, pytestCheckHook
, setuptools
, types-colorama
, types-setuptools
}:

buildPythonPackage rec {
  pname = "beautysh";
  version = "6.2.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "lovesegfault";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-rPeGRcyNK45Y7OvtzaIH93IIzexBf/jM1SzYP0phQ1o=";
  };

  patches = [
    # https://github.com/lovesegfault/beautysh/pull/247
    (fetchpatch {
      name = "poetry-to-poetry-core.patch";
      url = "https://github.com/lovesegfault/beautysh/commit/5f4fcac083fa68568a50f3c2bcee3ead0f3ca7c5.patch";
      hash = "sha256-H/kIJKww5ouWu8rmRkaMOXcsq2daZWDdwxBqbc99x0s=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'types-setuptools = "^57.4.0"' 'types-setuptools = "*"'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    colorama
    setuptools
    types-colorama
    types-setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "beautysh"
  ];

  meta = with lib; {
    description = "Tool for beautifying Bash scripts";
    homepage = "https://github.com/lovesegfault/beautysh";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "beautysh";
  };
}
