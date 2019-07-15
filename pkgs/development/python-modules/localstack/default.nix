{ stdenv, python }:


let
  py = python.override {
    packageOverrides = self: super: {
      elasticsearch = super.elasticsearch.overridePythonAttrs (oldAttrs: rec {
        version = "6.4.0";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "1bar2as905c1632xkbmm9rz95clwhxz5qsd5lysh9wc3w9gb2npv";
        };
      });

      flask-swagger = super.flask-swagger.overridePythonAttrs (oldAttrs: rec {
        version = "0.2.12";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "09pk8vdza31c4whmi54ciby3kqr38ih7g4g48r3ig4w143zmzrf0";
        };
      });

      psutil = super.psutil.overridePythonAttrs (oldAttrs: rec {
        version = "5.4.8";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "1hyna338sml2cl1mfb2gs89np18z27mvyhmq4ifh22x07n7mq9kf";
        };
      });

      rsa = super.rsa.overridePythonAttrs (oldAttrs: rec {
        version = "3.4.2";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "25df4e10c263fb88b5ace923dd84bf9aa7f5019687b5e55382ffcdb8bede9db5";
        };
      });
      pyyaml = super.pyyaml.overridePythonAttrs (oldAttrs: rec {
        version = "3.13";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "3ef3092145e9b70e3ddd2c7ad59bdd0252a94dfe3949721633e41344de00a6bf";
        };
      });
    };
  };
in py.pkgs.buildPythonPackage rec {
version = "0.9.6";
  pname = "localstack";
  src = py.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "0b207klhad4qnfy0g0ym89gqbw6gvsjgjwkirfdd1jyr69v734r1";
  };

  patchPhase = ''
    substituteInPlace requirements.txt --replace "flask-cors==3.0.3" "flask-cors==3.0.8"
    substituteInPlace requirements.txt --replace "flask==1.0.2" "flask==1.0.3"
    substituteInPlace requirements.txt --replace "pyopenssl==17.5.0" "pyopenssl==19.0.0"
    substituteInPlace requirements.txt --replace "airspeed==0.5.10" "airspeed==0.5.11"
  '';

  propagatedBuildInputs = with py.pkgs; [ boto botocore boto3 psutil flake8 flask-cors xmltodict flake8-quotes flask jsonpath_rw pyopenssl amazon_kclpy moto-ext localstack-ext requests-aws4auth docopt pyyaml localstack-client airspeed awscli flask-swagger pympler coverage python-coveralls yappi elasticsearch nose subprocess32-ext responses docker python-jose pytz cfn-lint aws-xray-sdk jsondiff cachetools dnslib warrant-ext pyaes srp-ext pyminifier python-jose-ext envs pycryptodomex ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://localstack.cloud;
    description = "Local AWS cloud stack";
    license = licenses.asl20;
  };
}
