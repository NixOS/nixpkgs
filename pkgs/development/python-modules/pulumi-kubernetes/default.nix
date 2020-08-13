{ lib
, buildPythonPackage
, fetchFromGitHub
, pulumi
, parver
, semver
, requests
, isPy27
}:

buildPythonPackage rec {
  pname = "pulumi-kubernetes";
  version = "1.6.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumi-kubernetes";
    rev = "v${version}";
    sha256 = "19q5xp6rjxg3j5xli8rd5v4jjm88bnbf837g3mgz538w1df0859v";
  };

  propagatedBuildInputs = [
    pulumi
    parver
    semver
    requests
  ];

  preBuild = ''
    cp README.md sdk/python/
    cd sdk/python

    substituteInPlace setup.py \
      --replace "$" "" \
      --replace "{VERSION}" "${version}" \
      --replace "{PLUGIN_VERSION}" "v${version}" \
      --replace "requests>=2.21.0,<2.22.0" "requests"
  '';

  # checks require cloud resources
  doCheck = false;

  meta = with lib; {
    description = "Pulumi python kubernetes provider";
    homepage = "https://github.com/pulumi/pulumi-kubernetes";
    license = licenses.asl20;
    maintainers = with maintainers; [ costrouc ];
  };
}
