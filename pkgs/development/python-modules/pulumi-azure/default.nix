{ lib
, buildPythonPackage
, fetchFromGitHub
, pulumi
, parver
, semver
, isPy27
}:

buildPythonPackage rec {
  pname = "pulumi-azure";
  version = "2.4.1";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumi-azure";
    rev = "v${version}";
    sha256 = "144c2xzr9mzlb6fkzzvsav1ljhsc8rqgx0mbs7k360nigsc7vw3x";
  };

  propagatedBuildInputs = [
    pulumi
    parver
    semver
  ];

  preBuild = ''
    cd sdk/python

    substituteInPlace setup.py \
      --replace "$" "" \
      --replace "{VERSION}" "${version}" \
      --replace "{PLUGIN_VERSION}" "v${version}"
  '';

  # checks require cloud resources
  doCheck = false;

  meta = with lib; {
    description = "Pulumi python azure provider";
    homepage = "https://github.com/pulumi/pulumi-azure";
    license = licenses.asl20;
    maintainers = with maintainers; [ costrouc ];
  };
}
