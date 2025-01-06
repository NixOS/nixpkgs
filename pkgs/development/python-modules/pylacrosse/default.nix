{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  mock,
  pyserial,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pylacrosse";
  version = "0.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hthiery";
    repo = "python-lacrosse";
    tag = version;
    hash = "sha256-jrkehoPLYbutDfxMBO/vlx4nMylTNs/gtvoBTFHFsDw=";
  };

  patches = [
    # Migrate to pytest, https://github.com/hthiery/python-lacrosse/pull/17
    (fetchpatch2 {
      url = "https://github.com/hthiery/python-lacrosse/commit/cc2623c667bc252360a9b5ccb4fc05296cf23d9c.patch?full_index=1";
      hash = "sha256-LKryLnXMKj1lVClneyHNVOWM5KPPhOGy0/FX/7Qy/jU=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "version = version," "version = '${version}',"
  '';

  propagatedBuildInputs = [ pyserial ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pylacrosse" ];

  meta = with lib; {
    description = "Python library for Jeelink LaCrosse";
    mainProgram = "pylacrosse";
    homepage = "https://github.com/hthiery/python-lacrosse";
    license = with licenses; [ lgpl2Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
