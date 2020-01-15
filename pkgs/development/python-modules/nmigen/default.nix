{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
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
  version = "unstable-2019-08-31";
  realVersion = lib.substring 0 7 src.rev;

  src = fetchFromGitHub {
    owner = "m-labs";
    repo = "nmigen";
    rev = "2e206220462c67aa6ae97f7515a2191440fd61b3";
    sha256 = "0y3w6vd493jqm9b8ppgwzs02v1al8w1n5gylljlsw70ci7fyk4qa";
  };

  disabled = pythonOlder "3.6";

  propagatedBuildInputs = [ pyvcd bitarray jinja2 ];

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
    substituteInPlace setup.py \
      --replace 'versioneer.get_version()' '"${realVersion}"'

    substituteInPlace nmigen/_toolchain.py \
      --replace 'overrides = {}' \
                'overrides = ${builtins.toJSON toolchainOverrides}'
  '';

  meta = with lib; {
    description = "A refreshed Python toolbox for building complex digital hardware";
    homepage = https://github.com/m-labs/nmigen;
    license = licenses.bsd0;
    maintainers = with maintainers; [ emily ];
  };
}
