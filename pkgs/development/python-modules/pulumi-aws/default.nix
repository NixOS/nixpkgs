{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pulumi
, parver
, semver
, isPy27
}:

buildPythonPackage rec {
  pname = "pulumi-aws";
  # version is independant of pulumi's.
  version = "5.3.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumi-aws";
    rev = "v${version}";
    sha256 = "sha256-LrWiNYJeQQvXJDOxklRO86VSiaadvkOepQVPhh2BBkk=";
  };

  propagatedBuildInputs = [
    pulumi
    parver
    semver
  ];

  postPatch = ''
    cd sdk/python
  '';

  # checks require cloud resources
  doCheck = false;
  pythonImportsCheck = ["pulumi_aws"];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "Pulumi python amazon web services provider";
    homepage = "https://github.com/pulumi/pulumi-aws";
    license = licenses.asl20;
    maintainers = with maintainers; [ costrouc ];
  };
}
