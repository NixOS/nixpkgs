{ lib
, buildPythonPackage
, fetchFromGitHub
, pulumi
, parver
, semver
, isPy27
}:

buildPythonPackage rec {
  pname = "pulumi-aws";
  version = "1.29.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumi-aws";
    rev = "v${version}";
    sha256 = "0qmaz3fqnwh6yrw3rr0hr5nkh9a0das37a40gybsxnzkdlg66zvi";
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
    description = "Pulumi python amazon web services provider";
    homepage = "https://github.com/pulumi/pulumi-aws";
    license = licenses.asl20;
    maintainers = with maintainers; [ costrouc ];
  };
}
