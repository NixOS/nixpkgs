{ stdenv
, lib
, buildPythonPackage
, cargo
, cffi
, fetchPypi
, glean-parser
, iso8601
<<<<<<< HEAD
, lmdb
, pkg-config
, pytest-localserver
, pytestCheckHook
, python
=======
, pytest-localserver
, pytestCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pythonOlder
, rustc
, rustPlatform
, semver
, setuptools-rust
}:

buildPythonPackage rec {
  pname = "glean-sdk";
<<<<<<< HEAD
  version = "52.7.0";
=======
  version = "52.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-sLjdGHiS7Co/oA9gQyAFkD14tAYjmwjWcPr4CRrzw/0=";
=======
    hash = "sha256-TTV6oydUP2znEOm7KZElugNDfROnlPmyC19Ig1H8/wM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
<<<<<<< HEAD
    hash = "sha256-5TlgWcLmjklxhtDbB0aRF71iIRTJwetFj1Jii1DGdvU=";
=======
    hash = "sha256-Np2TfgKP3yfJqA4WZyyedGp9XtKJjDikUov5pvB/opk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cargo
<<<<<<< HEAD
    pkg-config
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    rustc
    rustPlatform.cargoSetupHook
    setuptools-rust
  ];

<<<<<<< HEAD
  buildInputs = [
    lmdb
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    cffi
    glean-parser
    iso8601
    semver
  ];

  nativeCheckInputs = [
    pytest-localserver
    pytestCheckHook
  ];

  disabledTests = [
    # RuntimeError: No ping received.
    "test_client_activity_api"
<<<<<<< HEAD
    "test_flipping_upload_enabled_respects_order_of_events"
  ];

  postInstallCheck = lib.optionalString (stdenv.hostPlatform.parsed.kernel.execFormat == lib.systems.parse.execFormats.elf) ''
    readelf -a $out/${python.sitePackages}/glean/libglean_ffi.so | grep -F 'Shared library: [liblmdb.so'
  '';

=======
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [
    "glean"
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Telemetry client libraries and are a part of the Glean project";
    homepage = "https://mozilla.github.io/glean/book/index.html";
    license = licenses.mpl20;
    maintainers = with maintainers; [ melling ];
  };
}
