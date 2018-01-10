{ stdenv
, buildPythonPackage
, fetchPypi
, awscli
, prompt_toolkit
, boto3
, configobj
, pygments
}:

buildPythonPackage rec {
  pname = "aws-shell";
  version = "0.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pw9lrdjl24n6lrs6lnqpyiyic8bdxgvhyqvb2rx6kkbjrfhhgv5";
  };

  # Why does it propagate packages that are used for testing?
  propagatedBuildInputs = [
    awscli
    prompt_toolkit
    boto3
    configobj
    pygments
  ];

  #Checks are failing due to missing TTY, which won't exist.
  doCheck = false;
  preCheck = ''
    mkdir -p check-phase
    export HOME=$(pwd)/check-phase
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/awslabs/aws-shell;
    description = "An integrated shell for working with the AWS CLI";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
