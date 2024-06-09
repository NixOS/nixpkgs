{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  can,
  cobs,
  libpcap,
  nunavut,
  numpy,
  pyserial,
  pytestCheckHook,
  pytest-asyncio,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pycyphal";
  version = "1.18.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "OpenCyphal";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-XkH0wss8ueh/Wwz0lhvQShOp3a4X9lNdosT/sMe7p4Q=";
    fetchSubmodules = true;
  };

  propagatedBuildInputs = [
    numpy
    nunavut
  ];

  passthru.optional-dependencies = {
    transport-can-pythoncan = [ can ] ++ can.optional-dependencies.serial;
    transport-serial = [
      cobs
      pyserial
    ];
    transport-udp = [ libpcap ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ] ++ builtins.foldl' (x: y: x ++ y) [ ] (builtins.attrValues passthru.optional-dependencies);

  preCheck = ''
    export HOME=$TMPDIR
    export PYTHONASYNCIODEBUG=1
    python -c ${lib.escapeShellArg ''
      import pycyphal
      pycyphal.dsdl.compile_all(
        [
          "demo/public_regulated_data_types/uavcan",
          "demo/custom_data_types/sirius_cyber_corp",
        ],
        output_directory=".dsdl_compiled",
      )
    ''}
    export PYTHONPATH="$(pwd)/.dsdl_compiled:$PYTHONPATH"
  '';

  # These require extra permissions and/or actual hardware connected
  disabledTestPaths = [
    "pycyphal/application/__init__.py"
    "pycyphal/application/_transport_factory.py"
    "pycyphal/transport/udp/_ip/_link_layer.py"
    "pycyphal/transport/udp/_ip/_v4.py"
    "tests/application"
    "tests/demo"
    "tests/dsdl"
    "tests/presentation"
    "tests/transport"
  ];

  pythonImportsCheck = [ "pycyphal" ];

  meta = with lib; {
    description = "A full-featured implementation of the Cyphal protocol stack in Python";
    longDescription = ''
      Cyphal is an open technology for real-time intravehicular distributed computing and communication based on modern networking standards (Ethernet, CAN FD, etc.).
    '';
    homepage = "https://opencyphal.org/";
    changelog = "https://github.com/OpenCyphal/pycyphal/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = teams.ororatech.members;
  };
}
