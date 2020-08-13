{ lib
, buildPythonPackage
, fetchFromGitHub
, pulumi
, parver
, semver
, isPy27
}:

buildPythonPackage rec {
  pname = "pulumi-digitalocean";
  version = "1.9.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumi-digitalocean";
    rev = "v${version}";
    sha256 = "1bd0qks159hsva0pl5c28pb3i812h0ib24l2pdfcf5q775m33i70";
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
    description = "Pulumi python digital ocean provider";
    homepage = "https://github.com/pulumi/pulumi-digitalocean";
    license = licenses.asl20;
    maintainers = with maintainers; [ costrouc ];
  };
}
