{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, setuptools_scm
, pyvcd
, bitarray
, jinja2

# nmigen.{test,build} call out to these
, yosys
, symbiyosys
, nextpnr ? null
, icestorm ? null
, trellis ? null

# for tests
, yices
}:

buildPythonPackage rec {
  pname = "nmigen";
  version = "unstable-2019-09-28";
  # python setup.py --version
  realVersion = "0.1.dev689+g${lib.substring 0 7 src.rev}";

  src = fetchFromGitHub {
    owner = "m-labs";
    repo = "nmigen";
    rev = "a02e3750bfeba44bcaad4c5de8d9eb0ef055d9c6";
    sha256 = "0m399c2nm7y54q2f0fbkmi4h35csbc2llckm6k9kqdf5qc6355wd";
  };

  disabled = pythonOlder "3.6";

  nativeBuildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [ setuptools pyvcd bitarray jinja2 ];

  checkInputs = [ yosys yices ];

  postPatch = let
    tool = pkg: name:
      if pkg == null then {} else { ${name} = "${pkg}/bin/${name}"; };

    # Only FOSS toolchain supported out of the box, sorry!
    toolchainOverrides =
      tool yosys "yosys" //
      tool symbiyosys "sby" //
      tool nextpnr "nextpnr-ice40" //
      tool nextpnr "nextpnr-ecp5" //
      tool icestorm "icepack" //
      tool trellis "ecppack";
  in ''
    substituteInPlace nmigen/_toolchain.py \
      --replace 'overrides = {}' \
                'overrides = ${builtins.toJSON toolchainOverrides}'
  '';

  preBuild = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION="${realVersion}"
  '';

  meta = with lib; {
    description = "A refreshed Python toolbox for building complex digital hardware";
    homepage = https://github.com/m-labs/nmigen;
    license = licenses.bsd0;
    maintainers = with maintainers; [ emily ];
  };
}
