{ lib
, buildPythonPackage
, fetchFromGitHub
, protobuf
, dill
, grpcio
, pulumi-bin
, isPy27
}:

buildPythonPackage rec {
  pname = "pulumi";
  version = "1.14.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumi";
    rev = "v${version}";
    sha256 = "1qx485dy5ixx83nfar146br021wlgswqp7ia8lpi5nk880v3izs7";
  };

  propagatedBuildInputs = [
    protobuf
    dill
    grpcio
  ];

  checkInputs = [
    pulumi-bin
  ];

  postConfigure = ''
    cp README.md sdk/python/lib
    cd sdk/python/lib

    substituteInPlace setup.py \
      --replace "$" "" \
      --replace "{VERSION}" "${version}"
  '';

  checkPhase = ''
    python -m unittest discover -s test
  '';

  meta = with lib; {
    description = "Modern Infrastructure as Code. Any cloud, any language";
    homepage = "https://github.com/pulumi/pulumi";
    license = licenses.asl20;
    maintainers = with maintainers; [ costrouc ];
  };
}
