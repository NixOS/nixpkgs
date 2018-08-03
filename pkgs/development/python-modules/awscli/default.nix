{ lib, buildPythonApplication, fetchPypi
, botocore, colorama, docutils, rsa, s3transfer, pyyaml
, groff, less
}:

buildPythonPackage rec {
  pname = "awscli";
  version = "1.15.66";

  src = fetchPypi {
    inherit pname version;
    sha256 = "004fbd3bb8932465205675a7de94460b5c2d45ddd6916138a2c867e4d0f2a4c4";
  };

  # No tests included
  doCheck = false;

  propagatedBuildInputs = [
    botocore
    colorama
    docutils
    rsa
    s3transfer
    pyyaml
  ];

  makeWrapperArgs = [
    "--prefix PATH : ${groff}/bin:${less}/bin"
  ];

  postInstall = ''
    mkdir -p $out/etc/bash_completion.d
    echo "complete -C $out/bin/aws_completer aws" > $out/etc/bash_completion.d/awscli
    mkdir -p $out/share/zsh/site-functions
    mv $out/bin/aws_zsh_completer.sh $out/share/zsh/site-functions
    rm $out/bin/aws.cmd
  '';

  meta = with lib; {
    homepage = https://aws.amazon.com/cli/;
    description = "Unified tool to manage your AWS services";
    license = licenses.asl20;
    maintainers = with maintainers; [ muflax ];
  };
}
