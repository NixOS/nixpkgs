{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, fetchpatch
, poetry-core
, aiohttp
, async-upnp-client
, attrs
, click
, importlib-metadata
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python-songpal";
  version = "0.13";

  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "rytilahti";
    repo = "python-songpal";
    rev = version;
    sha256 = "124w6vfn992845k09bjv352havk8pg590b135m37h1x1m7fmbpwa";
  };

  patches = [
    # https://github.com/rytilahti/python-songpal/pull/90
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/rytilahti/python-songpal/commit/56b634790d94b2f9788d5af3d5cedff47f1e42c2.patch";
      sha256 = "0yc0mrb91ywk77nd4mxvyc0p2kjz2w1p395755a32ls30zw2bs27";
    })
  ];

  postPatch = ''
    # https://github.com/rytilahti/python-songpal/issues/91
    substituteInPlace pyproject.toml \
      --replace 'click = "^7"' 'click = "*"'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    async-upnp-client
    attrs
    click
    importlib-metadata
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "songpal" ];

  meta = with lib; {
    description = "Python library for interfacing with Sony's Songpal devices";
    homepage = "https://github.com/rytilahti/python-songpal";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dotlambda ];
  };
}
