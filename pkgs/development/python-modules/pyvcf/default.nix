{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
}:

buildPythonPackage rec {
  pname = "PyVCF";
  version = "0.6.8";

  src = fetchFromGitHub {
    owner = "jamescasbon";
    repo = "PyVCF";
    rev = "476169cd457ba0caa6b998b301a4d91e975251d9";
    sha256 = "0qf9lwj7r2hjjp4bd4vc7nayrhblfm4qcqs4dbd43a6p4bj2jv5p";
  };

  checkInputs = [ pytest ];

  meta = with lib; {
    homepage = "https://pyvcf.readthedocs.io/en/latest/index.html";
    description = "A VCF (Variant Call Format) Parser for Python, supporting version 4.0 and 4.1";
    license = licenses.bsd3;
    maintainers = with maintainers; [ scalavision ];
    longDescription = ''
      The intent of this module is to mimic the csv module in the Python stdlib, 
      as opposed to more flexible serialization formats like JSON or YAML. 
      vcf will attempt to parse the content of each record based on the data 
      types specified in the meta-information lines
    '';
  };
}
