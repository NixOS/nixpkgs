{ lib
, buildPythonPackage
, fetchFromGitHub
, pulumi
, parver
, semver
, isPy27
}:

buildPythonPackage rec {
  pname = "pulumi-random";
  version = "1.6.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumi-random";
    rev = "v${version}";
    sha256 = "18wyq7c0gi137j2bpjnbf6rwqflh6q4sp9xfmbd1dc31mbr834wf";
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
    description = "Pulumi python random provider";
    homepage = "https://github.com/pulumi/pulumi-random";
    license = licenses.asl20;
    maintainers = with maintainers; [ costrouc ];
  };
}
