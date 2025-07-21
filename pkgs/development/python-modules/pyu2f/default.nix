{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  six,
  mock,
  pyfakefs,
  pytest-forked,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyu2f";
  version = "0.1.5a";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "google";
    repo = "pyu2f";
    tag = version;
    sha256 = "0mx7bn1p3n0fxyxa82wg3c719hby7vqkxv57fhf7zvhlg2zfnr0v";
  };

  propagatedBuildInputs = [ six ];

  postPatch = ''
    for path in \
      customauthenticator_test.py \
      hardware_test.py \
      hidtransport_test.py \
      localauthenticator_test.py \
      model_test.py \
      u2f_test.py \
      util_test.py \
      hid/macos_test.py; \
    do
      # https://docs.python.org/3/whatsnew/3.12.html#id3
      substituteInPlace pyu2f/tests/$path \
        --replace "assertEquals" "assertEqual" \
        --replace "assertRaisesRegexp" "assertRaisesRegex"
    done
  '';

  nativeCheckInputs = [
    mock
    pyfakefs
    pytest-forked
    pytestCheckHook
  ];

  disabledTestPaths = [
    # API breakage with pyfakefs>=5.0
    "pyu2f/tests/hid/linux_test.py"
  ];

  meta = with lib; {
    description = "U2F host library for interacting with a U2F device over USB";
    homepage = "https://github.com/google/pyu2f";
    license = licenses.asl20;
    maintainers = with maintainers; [ prusnak ];
  };
}
