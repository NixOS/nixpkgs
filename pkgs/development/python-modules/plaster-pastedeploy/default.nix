{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, plaster
, pastedeploy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "plaster-pastedeploy";
  version = "0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c231130cb86ae414084008fe1d1797db7e61dc5eaafb5e755de21387c27c6fae";
  };

  patches = [
    # Fix tests compatibility with pastedeploy 2+
    # https://github.com/Pylons/plaster_pastedeploy/pull/17
    (fetchpatch {
      url = "https://github.com/Pylons/plaster_pastedeploy/commit/d77d81a57e917c67a20332beca8f418651172905.patch";
      sha256 = "0n5vnqn8kad41kn9grcwiic6c6rhvy1ji3w81s2v9xyk0bd9yryf";
    })
  ];

  propagatedBuildInputs = [ plaster pastedeploy ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "PasteDeploy binding to the plaster configuration loader";
    homepage = "https://github.com/Pylons/plaster_pastedeploy";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
