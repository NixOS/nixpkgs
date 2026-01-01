{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
<<<<<<< HEAD
=======
  fetchpatch2,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  mashumaro,
  orjson,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  syrupy,
  yarl,
}:

buildPythonPackage rec {
  pname = "powerfox";
<<<<<<< HEAD
  version = "2.0.0";
  pyproject = true;

=======
  version = "1.3.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "klaasnicolaas";
    repo = "python-powerfox";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-ygzO4/KZ9XUBjLVq48gvyZVEVRB1VJV6DpuHGKNXP54=";
  };

=======
    hash = "sha256-oGOKh+/KCR7eFi4b8TrLiBiOfauhUhKkRvPMejwelJY=";
  };

  patches = [
    # requires poetry-core>=2.0
    (fetchpatch2 {
      url = "https://github.com/klaasnicolaas/python-powerfox/commit/e3f1e39573fc278cd2800a2d4f4315cf0aff592b.patch";
      includes = [ "pyproject.toml" ];
      hash = "sha256-hkXLT3IWBVlbAwWvu/erENEsxOuIb8wv9UIVtAZqMPc=";
      revert = true;
    })
  ];

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    mashumaro
    orjson
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "powerfox" ];

  meta = {
    description = "Asynchronous Python client for the Powerfox devices";
    homepage = "https://github.com/klaasnicolaas/python-powerfox";
    changelog = "https://github.com/klaasnicolaas/python-powerfox/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
