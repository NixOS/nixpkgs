{ lib
, buildPythonPackage
, fetchFromGitHub
, pulumi
, parver
, semver
, isPy27
}:

buildPythonPackage rec {
  pname = "pulumi-gcp";
  version = "2.12.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumi-gcp";
    rev = "v${version}";
    sha256 = "044s01zjjdia6x4ah51y0ln9nb9sl7g1zqcqakwxdfhr159dspb9";
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
    description = "Pulumi python google cloud platform provider";
    homepage = "https://github.com/pulumi/pulumi-gcp";
    license = licenses.asl20;
    maintainers = with maintainers; [ costrouc ];
  };
}
