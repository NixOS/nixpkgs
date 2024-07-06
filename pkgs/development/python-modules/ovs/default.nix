{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, pytest
, sortedcontainers
, openvswitch
}:

buildPythonPackage rec {
  pname = "ovs";
  inherit (openvswitch) version src;
  sourceRoot = "${openvswitch.name}/python";

  # Fix up version generation / directories generation for binaries and stuff by Makefile.
  # We do not need it here.
  prePatch = ''
    substituteInPlace setup.py \
      --replace 'exec(open("ovs/version.py").read())' 'VERSION = "${version}"' \
      --replace 'open("ovs/dirs.py")' 'pass'
  '';

  buildInputs = [ pytest openvswitch ];

  propagatedBuildInputs = [ sortedcontainers ];

  doCheck = false; # TODO: test only ovstest

  meta = with lib; {
    description = "Open vSwitch library for Python.";
    homepage = "https://github.com/openvswitch/ovs";
    license = licenses.asl20;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
