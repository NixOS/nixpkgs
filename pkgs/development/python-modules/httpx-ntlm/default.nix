{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, httpx
, pyspnego
, pythonOlder
}:

buildPythonPackage rec {
  pname = "httpx-ntlm";
  version = "1.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "httpx_ntlm";
    inherit version;
    hash = "sha256-a1a5laZ4tNOtpVDFCK1t2IXWbyJytZMhuad2JtmA52I=";
  };

  patches = [
    # Update version specifiers, https://github.com/ulodciv/httpx-ntlm/pull/15
    (fetchpatch {
      name = "update-version-specifiers.patch";
      url = "https://github.com/ulodciv/httpx-ntlm/commit/dac67a957c5c23df29d4790ddbc7cc4bccfc0e35.patch";
      hash = "sha256-YtgRrgGG/x7jvNg+NuQIrkOUdyD6Bk53fRaiXBwiV+o=";
    })
  ];

  propagatedBuildInputs = [
    httpx
    pyspnego
  ];

  # https://github.com/ulodciv/httpx-ntlm/issues/5
  doCheck = false;

  pythonImportsCheck = [
    "httpx_ntlm"
  ];

  meta = with lib; {
    description = "NTLM authentication support for HTTPX";
    homepage = "https://github.com/ulodciv/httpx-ntlm";
    license = licenses.isc;
    maintainers = with maintainers; [ fab ];
  };
}
