{
  lib,
  boto3,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  typing-extensions,
}:
let
  toUnderscore = str: builtins.replaceStrings [ "-" ] [ "_" ] str;

  buildMypyBoto3Package =
    serviceName: version: hash:
    buildPythonPackage {
      pname = "mypy-boto3-${serviceName}";
      inherit version;
      pyproject = true;

      disabled = pythonOlder "3.7";

      src = fetchPypi {
        pname = "mypy_boto3_${toUnderscore serviceName}";
        inherit version hash;
      };

      build-system = [ setuptools ];

      dependencies = [ boto3 ] ++ lib.optionals (pythonOlder "3.12") [ typing-extensions ];

      # Project has no tests
      doCheck = false;

      pythonImportsCheck = [ "mypy_boto3_${toUnderscore serviceName}" ];

      meta = with lib; {
        description = "Type annotations for boto3 ${serviceName}";
        homepage = "https://github.com/youtype/mypy_boto3_builder";
        license = with licenses; [ mit ];
        maintainers = with maintainers; [
          fab
          mbalatsko
        ];
      };
    };
in
rec {
  mypy-boto3-accessanalyzer =
    buildMypyBoto3Package "accessanalyzer" "1.40.0"
      "sha256-hY5aShO9E5zMwPSUUucjgG2Bod0lAm51BZyLP/1JLgY=";

  mypy-boto3-account =
    buildMypyBoto3Package "account" "1.40.0"
      "sha256-isNBcceGQXkVPZQ9XNVGt9eCHxUidaHVJbuPmSjYOcc=";

  mypy-boto3-acm =
    buildMypyBoto3Package "acm" "1.40.0"
      "sha256-E2wUtUSMX4Lyj+HioQD6km3sGGETjgzujJbEewOHc5M=";

  mypy-boto3-acm-pca =
    buildMypyBoto3Package "acm-pca" "1.40.1"
      "sha256-GZMeU5qLmE7eM6zSuS3e63ytY8C1jlnjUVkJmAiAoCo=";

  mypy-boto3-amp =
    buildMypyBoto3Package "amp" "1.40.0"
      "sha256-JM/pV41mxJqdIYWzaHdAO1DtXjvQD1pzG2nU10+2IUs=";

  mypy-boto3-amplify =
    buildMypyBoto3Package "amplify" "1.40.0"
      "sha256-B9APRl3tgbLaWHsXOdcaYDvkpEdQRO5P1PIbQecR7lo=";

  mypy-boto3-amplifybackend =
    buildMypyBoto3Package "amplifybackend" "1.40.0"
      "sha256-1aP+5IiJI1YepuiymxtltPbNNdSNKw1dHUn11eZEEAQ=";

  mypy-boto3-amplifyuibuilder =
    buildMypyBoto3Package "amplifyuibuilder" "1.40.0"
      "sha256-wBdq3kI0El1XZRuGMG2lN0Zjc1GIBOItMBvctF/10Wg=";

  mypy-boto3-apigateway =
    buildMypyBoto3Package "apigateway" "1.40.0"
      "sha256-mfMTQ3XSVHDjTjQEY/EL1xq4t0KRaPwG2Nu0Pwsbk3o=";

  mypy-boto3-apigatewaymanagementapi =
    buildMypyBoto3Package "apigatewaymanagementapi" "1.40.0"
      "sha256-wt5RDgTkJZv+GZURGu98gGJRvM0a63JTePQ9aDrwLaE=";

  mypy-boto3-apigatewayv2 =
    buildMypyBoto3Package "apigatewayv2" "1.40.0"
      "sha256-gfnF5uJodhhdWWdmTcD3N4GEwUZh/LsOZ9C99MPCHWQ=";

  mypy-boto3-appconfig =
    buildMypyBoto3Package "appconfig" "1.40.0"
      "sha256-n0P3k9Bs7ckTEim/cHXLQzt5qsjxzq59TYlOair61mU=";

  mypy-boto3-appconfigdata =
    buildMypyBoto3Package "appconfigdata" "1.40.0"
      "sha256-/6S/GdXeAYY9wdapWjcrCyaDmeijp6kSy63m0ITW3fs=";

  mypy-boto3-appfabric =
    buildMypyBoto3Package "appfabric" "1.40.0"
      "sha256-NtPZSYolKwbty/QgQHi5XeuBE6uDMM+hf3RRw+S9UtE=";

  mypy-boto3-appflow =
    buildMypyBoto3Package "appflow" "1.40.0"
      "sha256-w2NPLBdMrpFTuryOJtezSYU81kG4ZL2nIcRB0c5oL7M=";

  mypy-boto3-appintegrations =
    buildMypyBoto3Package "appintegrations" "1.40.0"
      "sha256-7su8sPB0QUQi+5ZQd701JYNVqpoIww3q0N4puBcszT4=";

  mypy-boto3-application-autoscaling =
    buildMypyBoto3Package "application-autoscaling" "1.40.0"
      "sha256-XMvGnZjdb8sQ8QES1CkZD7VkditEdudUGPVaYwF25Fk=";

  mypy-boto3-application-insights =
    buildMypyBoto3Package "application-insights" "1.40.0"
      "sha256-s1uRD7w/mw6T41zkD8PZA8+gLlcn8mWS2WGeWxk/FRc=";

  mypy-boto3-applicationcostprofiler =
    buildMypyBoto3Package "applicationcostprofiler" "1.40.0"
      "sha256-K5trJxvuYiP9hHB2Nz1uxKXzXrMJVwIqhU6DMVxide4=";

  mypy-boto3-appmesh =
    buildMypyBoto3Package "appmesh" "1.40.0"
      "sha256-ZMDdjJse4uyAnWIy/cwQQuAemTrUBdm8PYQp0LTuHgE=";

  mypy-boto3-apprunner =
    buildMypyBoto3Package "apprunner" "1.40.0"
      "sha256-xrpy1Eq+Kleg0oYEQY/UDXvUUdZp9B6rz4OrXo/A9bA=";

  mypy-boto3-appstream =
    buildMypyBoto3Package "appstream" "1.40.4"
      "sha256-AgYaQp4AQUly5DO83NgCojU7cKOP5LdStYr1X3lMAE0=";

  mypy-boto3-appsync =
    buildMypyBoto3Package "appsync" "1.40.0"
      "sha256-NgOa+Na/gU7IrtEJ8bVMJaSCNgTnGreX2TsjsAlIN+Y=";

  mypy-boto3-arc-zonal-shift =
    buildMypyBoto3Package "arc-zonal-shift" "1.40.0"
      "sha256-c8dkKeytZ3/lr1gWswCtcFGsHnv7F+7TOeNMNnocJhE=";

  mypy-boto3-athena =
    buildMypyBoto3Package "athena" "1.40.0"
      "sha256-2oQp9Va82Feyyf7ZEz7wv+y4mOK3TpZ586qvzCZwK/E=";

  mypy-boto3-auditmanager =
    buildMypyBoto3Package "auditmanager" "1.40.1"
      "sha256-p8jnTJigD8QuLe3vjZwE7ZyGgBblpSdM0II0Cr/xFS8=";

  mypy-boto3-autoscaling =
    buildMypyBoto3Package "autoscaling" "1.40.0"
      "sha256-tBk+8scAVeO8YMNDWWW4uQK8V+X9YLUP80vm3euq3gs=";

  mypy-boto3-autoscaling-plans =
    buildMypyBoto3Package "autoscaling-plans" "1.40.0"
      "sha256-YEMDbEZoS9BxDqB+ae30NSPlQkX6gt+V6+LZjAvanKI=";

  mypy-boto3-backup =
    buildMypyBoto3Package "backup" "1.40.0"
      "sha256-q7HoaGzpwKAPik9I6e9+esVbwH2zRrIhzPQoIW4juPA=";

  mypy-boto3-backup-gateway =
    buildMypyBoto3Package "backup-gateway" "1.40.0"
      "sha256-7FIXPtt4FMjxXbHtiO4qbS4wUfi10rmVODshIORlfhs=";

  mypy-boto3-batch =
    buildMypyBoto3Package "batch" "1.40.5"
      "sha256-RV7StAIpxSmwv9a+3YNGHKqym+y9A09fM4Cv2Qwj8f8=";

  mypy-boto3-billingconductor =
    buildMypyBoto3Package "billingconductor" "1.40.0"
      "sha256-XyGkubFi/5yoLG/5CGRNjtB7tKhOqP6PuTvhTsn3pQM=";

  mypy-boto3-braket =
    buildMypyBoto3Package "braket" "1.40.0"
      "sha256-YZKJblhTzoW0I/ozKw+RzELF9nJ0+3Z/zjZhb/lEd80=";

  mypy-boto3-budgets =
    buildMypyBoto3Package "budgets" "1.40.4"
      "sha256-6kCRDur13G+GTZK8R7gknc1J3L/E3YA4/xi+9qQhVp0=";

  mypy-boto3-ce =
    buildMypyBoto3Package "ce" "1.40.0"
      "sha256-O42YFgtlQoivQquLiQqHoHiT5NtQH8I4z6H+A41rrSE=";

  mypy-boto3-chime =
    buildMypyBoto3Package "chime" "1.40.0"
      "sha256-g4dwXPkMmQxjaSZt1RvRvVxRXWyeFosmwMaiCOtvuqY=";

  mypy-boto3-chime-sdk-identity =
    buildMypyBoto3Package "chime-sdk-identity" "1.40.0"
      "sha256-oPAwpEyXLywiumiOZ5b6YzplIHa10a4b5zMyb0M2IAU=";

  mypy-boto3-chime-sdk-media-pipelines =
    buildMypyBoto3Package "chime-sdk-media-pipelines" "1.40.0"
      "sha256-P+I+mG7Bhf83/Mdt3HG5y/nWiKTEjIjTebcBfZ789sY=";

  mypy-boto3-chime-sdk-meetings =
    buildMypyBoto3Package "chime-sdk-meetings" "1.40.0"
      "sha256-8BL5bNgUJegDMQnyGnLjSxzaPATF80av0lk+D+bEqgI=";

  mypy-boto3-chime-sdk-messaging =
    buildMypyBoto3Package "chime-sdk-messaging" "1.40.0"
      "sha256-Vtf4PVkKxCIYSyvOXMMo1r7ZskDVA0zw9Ql0elCsw28=";

  mypy-boto3-chime-sdk-voice =
    buildMypyBoto3Package "chime-sdk-voice" "1.40.0"
      "sha256-4gZRcx2z2PJcm/q1X7Ufe8RAAyHNhPEawRiLBWeWC+A=";

  mypy-boto3-cleanrooms =
    buildMypyBoto3Package "cleanrooms" "1.40.0"
      "sha256-pb1knX+zPd5xbTx8ilHmnD3WZUOzmBbiIzvORb3P6XQ=";

  mypy-boto3-cloud9 =
    buildMypyBoto3Package "cloud9" "1.40.0"
      "sha256-zs2trO/LmdKEyP+xhjHZCnWrI5loGEc7AiSQ7Hpq0rg=";

  mypy-boto3-cloudcontrol =
    buildMypyBoto3Package "cloudcontrol" "1.40.0"
      "sha256-38IFJI1enFd6XnWe81zuf80N23Orfl1CUCRt57g0zEE=";

  mypy-boto3-clouddirectory =
    buildMypyBoto3Package "clouddirectory" "1.40.0"
      "sha256-kMDdPCPFcwKQR5/MAlbyvGY4o7PHwQzQVGkzWLRg7Sk=";

  mypy-boto3-cloudformation =
    buildMypyBoto3Package "cloudformation" "1.40.0"
      "sha256-oL6q5WNV+z5etEOdZakZqeYfbqL2n/vwoD/WtFrYlfA=";

  mypy-boto3-cloudfront =
    buildMypyBoto3Package "cloudfront" "1.40.5"
      "sha256-vuRBMVk6gQ+mfNLG/QV/EjvwfX3mM3ttgK/zUsi0ghA=";

  mypy-boto3-cloudhsm =
    buildMypyBoto3Package "cloudhsm" "1.40.0"
      "sha256-GqcCTcfrPGdt1F2e2kFBZVJuK30sFiP+JSXYXV/sH7g=";

  mypy-boto3-cloudhsmv2 =
    buildMypyBoto3Package "cloudhsmv2" "1.40.0"
      "sha256-h/dMWTcSGu7IuI2G2G+gt3EbWV1SA4JpOcYiMtlGUxs=";

  mypy-boto3-cloudsearch =
    buildMypyBoto3Package "cloudsearch" "1.40.0"
      "sha256-sWGWNB+dBURSQhopDDm5rXsvolhDVi8oRshfG57vbw0=";

  mypy-boto3-cloudsearchdomain =
    buildMypyBoto3Package "cloudsearchdomain" "1.40.0"
      "sha256-pxLDikSrl8gZsvYbpmafQt4EG72lsrv4VESXTCuVQzc=";

  mypy-boto3-cloudtrail =
    buildMypyBoto3Package "cloudtrail" "1.40.0"
      "sha256-aV+fpcURVMZv7jOsZ/LF6edo4doNZPtCwdG4YEGKMYc=";

  mypy-boto3-cloudtrail-data =
    buildMypyBoto3Package "cloudtrail-data" "1.40.0"
      "sha256-1UfkYWjdEHdYQff3xCTH3jQapWyzc/L9pznEc/o5Stg=";

  mypy-boto3-cloudwatch =
    buildMypyBoto3Package "cloudwatch" "1.40.0"
      "sha256-SbEKbGXjkvk+jIXQHToTj+yzhUX1ob8VzT4awbWUAWs=";

  mypy-boto3-codeartifact =
    buildMypyBoto3Package "codeartifact" "1.40.0"
      "sha256-FyjlcLmx8cmYlTlzxI8AupyGJXwIWEh7OOtKeUA6vPk=";

  mypy-boto3-codebuild =
    buildMypyBoto3Package "codebuild" "1.40.5"
      "sha256-ReATcp8ORYv1MsyKGdt5WfSWeZ3emGfqJjswBeG/P5o=";

  mypy-boto3-codecatalyst =
    buildMypyBoto3Package "codecatalyst" "1.40.0"
      "sha256-cPLylCvda6iHWRcPMVaL/qEkeg7EzBs38G2mX1eP0ZI=";

  mypy-boto3-codecommit =
    buildMypyBoto3Package "codecommit" "1.40.0"
      "sha256-buG7f7h5ciaoS7Pq/8u8PsvAmqaJqYr4+rIiXxUVqaI=";

  mypy-boto3-codedeploy =
    buildMypyBoto3Package "codedeploy" "1.40.0"
      "sha256-jCHj0zHPXgQ303eM9naE4hr+6GP8OhjR8UeX6OeTEIU=";

  mypy-boto3-codeguru-reviewer =
    buildMypyBoto3Package "codeguru-reviewer" "1.40.0"
      "sha256-DGppntoDyUYwAo1XkJG7OQTK/E0B4F9y2qjnIQaRT7I=";

  mypy-boto3-codeguru-security =
    buildMypyBoto3Package "codeguru-security" "1.40.0"
      "sha256-T++PZg1Q9GQpdpMrkOXpMaW3NZe9bKgJAmqLflvJXgc=";

  mypy-boto3-codeguruprofiler =
    buildMypyBoto3Package "codeguruprofiler" "1.40.0"
      "sha256-C9gZsTj4dK7evyAo8v1DbSo4vIm+HIzth+m/F0OPigk=";

  mypy-boto3-codepipeline =
    buildMypyBoto3Package "codepipeline" "1.40.0"
      "sha256-wWJVXhlaRSBmDs0rA+Uqa36yBShPzUqFYB7qkkTCteg=";

  mypy-boto3-codestar =
    buildMypyBoto3Package "codestar" "1.35.0"
      "sha256-B9Aq+hh9BOzCIYMkS21IZYb3tNCnKnV2OpSIo48aeJM=";

  mypy-boto3-codestar-connections =
    buildMypyBoto3Package "codestar-connections" "1.40.0"
      "sha256-MJfhLtZ7XJxOvfnYruvPGr6yl7Dg71iKC65b57s3YUw=";

  mypy-boto3-codestar-notifications =
    buildMypyBoto3Package "codestar-notifications" "1.40.0"
      "sha256-AsC0tMY0LbaFxJgLK3QLDrXNOjLkZkvp60AwyQEkeRw=";

  mypy-boto3-cognito-identity =
    buildMypyBoto3Package "cognito-identity" "1.40.0"
      "sha256-uEEXHsqyaLnPGXs0wVrx+cjUkm8IykxTnWeBOBXb3DU=";

  mypy-boto3-cognito-idp =
    buildMypyBoto3Package "cognito-idp" "1.40.7"
      "sha256-n1n2O5k0hUHLiMEP2freTDMcYKximRt+yWt86BEjj9I=";

  mypy-boto3-cognito-sync =
    buildMypyBoto3Package "cognito-sync" "1.40.0"
      "sha256-3BylDhj1qWTDr/xeUxdnrKNXbXisMgXL0OoThhdoSZg=";

  mypy-boto3-comprehend =
    buildMypyBoto3Package "comprehend" "1.40.0"
      "sha256-KVfYSlwqY7/ufb+DEChO5Df3bfX0nw2W60YZW7UXSgk=";

  mypy-boto3-comprehendmedical =
    buildMypyBoto3Package "comprehendmedical" "1.40.0"
      "sha256-oJFrBdUov2dpl4XWV3HGHigKTvLAUtD2x1gzxzeK5oA=";

  mypy-boto3-compute-optimizer =
    buildMypyBoto3Package "compute-optimizer" "1.40.0"
      "sha256-CSfC9Kg73LydRU5aH4kqdc0pJWqEf98ebu6FOBE7oVU=";

  mypy-boto3-config =
    buildMypyBoto3Package "config" "1.40.0"
      "sha256-eukD7L3JzqvzK5mW9ESu9L62id1EHGhYdy+afYowtAc=";

  mypy-boto3-connect =
    buildMypyBoto3Package "connect" "1.40.7"
      "sha256-xhy39XaNffvBgpk9vlilQ9WG3yUFhCfN5EsIdSxUKrE=";

  mypy-boto3-connect-contact-lens =
    buildMypyBoto3Package "connect-contact-lens" "1.40.0"
      "sha256-sRuNGX0Xy9sQmHpWZtjbMYTSFgAzTAuNke4uHINz9q8=";

  mypy-boto3-connectcampaigns =
    buildMypyBoto3Package "connectcampaigns" "1.40.0"
      "sha256-nAOKVy+aH2gw8NZ8cNSYqQ0kFWV4Gb4oU6y1vHz3fpI=";

  mypy-boto3-connectcases =
    buildMypyBoto3Package "connectcases" "1.40.0"
      "sha256-dDHPNM+HVEIBXu9GFRtnnY+j5J31Z0gNfv/cd91QX4I=";

  mypy-boto3-connectparticipant =
    buildMypyBoto3Package "connectparticipant" "1.40.0"
      "sha256-+dXdtfYLf5LclRoNazidUwu9uClEFXi286bGgAVbWYU=";

  mypy-boto3-controltower =
    buildMypyBoto3Package "controltower" "1.40.0"
      "sha256-boRrDWiYtyKWUimJ7yb3uYPGSB/tmI2sEXNFacAPDic=";

  mypy-boto3-cur =
    buildMypyBoto3Package "cur" "1.40.0"
      "sha256-swFOOGB/iVP98EUOfTohHCxzrLNf1bnX/cbQWC83PVw=";

  mypy-boto3-customer-profiles =
    buildMypyBoto3Package "customer-profiles" "1.40.0"
      "sha256-fMWdXDlTjSkf5R5U+cd85E5qEEHAyl4Mc0v1W2rW4WA=";

  mypy-boto3-databrew =
    buildMypyBoto3Package "databrew" "1.40.0"
      "sha256-pw+1wvGLr4uYdUuAnDwSQeJ0KLe9JNzfRYnZJTTNrIU=";

  mypy-boto3-dataexchange =
    buildMypyBoto3Package "dataexchange" "1.40.0"
      "sha256-VVmG1myGH8FJpqQ63GDMYH5KVAPsv+Pmnc/WxHpTcHs=";

  mypy-boto3-datapipeline =
    buildMypyBoto3Package "datapipeline" "1.40.0"
      "sha256-QhTjQ1ZZX8zQzna2rUu2zF5jd51E4mJ/+v45sd9p3lA=";

  mypy-boto3-datasync =
    buildMypyBoto3Package "datasync" "1.40.0"
      "sha256-I5xvx5UCp1h2H1c2xI6mSI4ZaXsONs/09/BJfRXCr3A=";

  mypy-boto3-dax =
    buildMypyBoto3Package "dax" "1.40.0"
      "sha256-8WIQT3ZFLScp4zge1Cu5OkxeXS9GCCPdYlwJPwwz1GU=";

  mypy-boto3-detective =
    buildMypyBoto3Package "detective" "1.40.0"
      "sha256-npKb6WwOkXnxh5YYQ4spoS17J5oyzI4u1hw/2+d7dH0=";

  mypy-boto3-devicefarm =
    buildMypyBoto3Package "devicefarm" "1.40.0"
      "sha256-6v65flOExW7V8UfoyPaBcUQDYjhJ2jyuQpXMZW+ajCI=";

  mypy-boto3-devops-guru =
    buildMypyBoto3Package "devops-guru" "1.40.0"
      "sha256-aQR1CrCbisf0vApIjFXa5/oKC4Q1eT0AsLTg0EBojAs=";

  mypy-boto3-directconnect =
    buildMypyBoto3Package "directconnect" "1.40.0"
      "sha256-UmrcCxy3zK/cEkM/KCGnr4JEMOOjhNwBNRC6IiMm+NM=";

  mypy-boto3-discovery =
    buildMypyBoto3Package "discovery" "1.40.0"
      "sha256-7B/r3hmwde2URQF3ztv3Ruva+0IPq2uNAoY4lAHga80=";

  mypy-boto3-dlm =
    buildMypyBoto3Package "dlm" "1.40.0"
      "sha256-t+aKxZaK2Zx6QQ2AmlCUpjXhFtcma+nOKMXF1bkRfBY=";

  mypy-boto3-dms =
    buildMypyBoto3Package "dms" "1.40.0"
      "sha256-JT+/tWyrcEXCiPhfcJQYXsPAwKCKLPu+c3A+r4iJIVg=";

  mypy-boto3-docdb =
    buildMypyBoto3Package "docdb" "1.40.0"
      "sha256-GH91jmgaNkchW2fK8winBTP4IWUftwqFCqfJPqkDj9o=";

  mypy-boto3-docdb-elastic =
    buildMypyBoto3Package "docdb-elastic" "1.40.0"
      "sha256-TKVaVd92g+2bV5NNRnLuVZQw0lZycTyeyjB6UgV+iHc=";

  mypy-boto3-drs =
    buildMypyBoto3Package "drs" "1.40.0"
      "sha256-dtw54zAzP4HddWx0kZr7SzxmWiKCiiP6g4+aDRRid2k=";

  mypy-boto3-ds =
    buildMypyBoto3Package "ds" "1.40.0"
      "sha256-MjtEiMiKguv1RAeY4Cjk/apJlgi5jH/6avgMtdcp+2Q=";

  mypy-boto3-dynamodb =
    buildMypyBoto3Package "dynamodb" "1.40.0"
      "sha256-l/ZQBqFwb3y99TrRw6mRThC1N1QZTbStEgBOynw3a04=";

  mypy-boto3-dynamodbstreams =
    buildMypyBoto3Package "dynamodbstreams" "1.40.0"
      "sha256-x/0Scc259VN45rx94YT48Q3NS7nnd2oNRgxQAmy3nSQ=";

  mypy-boto3-ebs =
    buildMypyBoto3Package "ebs" "1.40.0"
      "sha256-p+NFAi4x4J6S4v0f2u0awDG+lb2V7r3XwgYwl5CvhHo=";

  mypy-boto3-ec2 =
    buildMypyBoto3Package "ec2" "1.40.7"
      "sha256-dr/9I5kl1nuCU6V3mtkzgwgmzU22Q22yAas2IFCRywM=";

  mypy-boto3-ec2-instance-connect =
    buildMypyBoto3Package "ec2-instance-connect" "1.40.0"
      "sha256-YmD2QCD6oc8HB3yNpj/ucXrbF3KVuVNiW8rK4UzPxGw=";

  mypy-boto3-ecr =
    buildMypyBoto3Package "ecr" "1.40.0"
      "sha256-dzPkK8ipL/2Tvr8DQ68TP9UmmP/r0yPYL/3nVc4oaH8=";

  mypy-boto3-ecr-public =
    buildMypyBoto3Package "ecr-public" "1.40.0"
      "sha256-/BYvjLnsA+u/7Jy54ApT9Ss5acGB6FFBzrWhby8ctxA=";

  mypy-boto3-ecs =
    buildMypyBoto3Package "ecs" "1.40.0"
      "sha256-f6FsEABh57bwQ+ffj4b0qds+7X5JGKyDRfuVR2W4J4A=";

  mypy-boto3-efs =
    buildMypyBoto3Package "efs" "1.40.0"
      "sha256-DQZUI72cnRt4YwHMQivMdL4y9B9EN2H7dIMmybcX/Uk=";

  mypy-boto3-eks =
    buildMypyBoto3Package "eks" "1.40.3"
      "sha256-vkqLHrhHhU4CsvLez2MDUHWwlU91i4i+DVEs5TM3Rp8=";

  mypy-boto3-elastic-inference =
    buildMypyBoto3Package "elastic-inference" "1.36.0"
      "sha256-duU3LIeW3FNiplVmduZsNXBoDK7vbO6ecrBt1Y7C9rU=";

  mypy-boto3-elasticache =
    buildMypyBoto3Package "elasticache" "1.40.0"
      "sha256-wOxSRFLJHcO1Vc26rFKaxe49l5/PKAxDBycvV0ER1Co=";

  mypy-boto3-elasticbeanstalk =
    buildMypyBoto3Package "elasticbeanstalk" "1.40.0"
      "sha256-uMYIfSNSkNPJnpRgCeM+HVccKZbxyrSXgkfvq+WyoAk=";

  mypy-boto3-elastictranscoder =
    buildMypyBoto3Package "elastictranscoder" "1.40.0"
      "sha256-4xpjAgNDfYP3Z8uPxINsLOQ1vvanXW1/QDbUcZ57e0Y=";

  mypy-boto3-elb =
    buildMypyBoto3Package "elb" "1.40.0"
      "sha256-/VNUPoXCvu+XIbq81YPL7wN1aCnec5K4Vv3ysVr2+eI=";

  mypy-boto3-elbv2 =
    buildMypyBoto3Package "elbv2" "1.40.0"
      "sha256-zxpAc7Z4Vm6Bzdq7bhdekg6HAUKe/3PXRviQ0f8p7NE=";

  mypy-boto3-emr =
    buildMypyBoto3Package "emr" "1.40.0"
      "sha256-crNaa6bqSP7fCsFV5CnAHazDpXrFkkb46ria2LWTDvY=";

  mypy-boto3-emr-containers =
    buildMypyBoto3Package "emr-containers" "1.40.0"
      "sha256-69FemTAsiAMYEcITc+5xrg+swrxgILdj3CwmgIIMi0c=";

  mypy-boto3-emr-serverless =
    buildMypyBoto3Package "emr-serverless" "1.40.0"
      "sha256-9Iz9FapUQCWa9bjmH0Ar9O1mtTv+ovWlxikddb5+Wlc=";

  mypy-boto3-entityresolution =
    buildMypyBoto3Package "entityresolution" "1.40.0"
      "sha256-/Xzo0KU2N14S39gkb1MnJV27anIN92ANcCbKl1b9YVw=";

  mypy-boto3-es =
    buildMypyBoto3Package "es" "1.40.0"
      "sha256-0lQVhW0/lc/xsR7QN66dMmT5ApN+SxYDZk78liqtqi4=";

  mypy-boto3-events =
    buildMypyBoto3Package "events" "1.40.0"
      "sha256-NifbOgZ8Q0oUnKchIt04RgMMDBXMiwJJCKDmax3j4Es=";

  mypy-boto3-evidently =
    buildMypyBoto3Package "evidently" "1.40.0"
      "sha256-pqXtqKztmI4gOfyvwgjNg0MShL/RPwVQhdcHHGlw7Qk=";

  mypy-boto3-finspace =
    buildMypyBoto3Package "finspace" "1.40.0"
      "sha256-rIdTU3A6jN0cpn6kQE0nPSqjYPqXUF2yyjMuvpnejpE=";

  mypy-boto3-finspace-data =
    buildMypyBoto3Package "finspace-data" "1.40.0"
      "sha256-jX1fYURsKptrn7rtyoekqvS81P42GiW5J7kS9aKw1c0=";

  mypy-boto3-firehose =
    buildMypyBoto3Package "firehose" "1.40.0"
      "sha256-Zzp7VoPaVIHX3KccxlFILesGNJP7f1p63uXLwN3rLcs=";

  mypy-boto3-fis =
    buildMypyBoto3Package "fis" "1.40.0"
      "sha256-0mNCSnKz/OTCM4vSwdSxkMVPEhsiYUOY+b+6wL/sIyM=";

  mypy-boto3-fms =
    buildMypyBoto3Package "fms" "1.40.0"
      "sha256-sTuTQ3ADgiApY0davzOBHz+jz21tp2C4L7Kq6j8dUvY=";

  mypy-boto3-forecast =
    buildMypyBoto3Package "forecast" "1.40.0"
      "sha256-mo2xp2XnApilK6zB+KZLt/KcJ6mTPskjidfZ0ju6Xss=";

  mypy-boto3-forecastquery =
    buildMypyBoto3Package "forecastquery" "1.40.0"
      "sha256-J/cpFdOZUL5B1LxtIBOnE++TdSA1sbqA7ckJ+Ag1Os0=";

  mypy-boto3-frauddetector =
    buildMypyBoto3Package "frauddetector" "1.40.0"
      "sha256-i76hozLLcN4Y5Jpg/92+6FSgStpw2SfF0HeRhQiRPqE=";

  mypy-boto3-fsx =
    buildMypyBoto3Package "fsx" "1.40.0"
      "sha256-ryCVtTJSbtLmStHUhZrNkUBm79mjZo4NZtf5QHONWLY=";

  mypy-boto3-gamelift =
    buildMypyBoto3Package "gamelift" "1.40.0"
      "sha256-KgMMWys21dHhDP9kQjxPeQtJBWfiOeSCtwuE9FIAzk8=";

  mypy-boto3-glacier =
    buildMypyBoto3Package "glacier" "1.40.0"
      "sha256-NBSrlhycsJqCgbiitfNmSAGcTPgZfkfx5DGm8ZhrRyc=";

  mypy-boto3-globalaccelerator =
    buildMypyBoto3Package "globalaccelerator" "1.40.0"
      "sha256-So/NDL0KF5iypLYitnJ/38C5RovqBGXcUhHtlEMnjMM=";

  mypy-boto3-glue =
    buildMypyBoto3Package "glue" "1.40.5"
      "sha256-ux3mdI2uZoWqEN7p8yvmWM8F3x8WzQUJaJK1j4fYvXE=";

  mypy-boto3-grafana =
    buildMypyBoto3Package "grafana" "1.40.0"
      "sha256-KQqyk9PFUttzDrZW7viev8xbumdud05EBdNoxz//hEY=";

  mypy-boto3-greengrass =
    buildMypyBoto3Package "greengrass" "1.40.0"
      "sha256-LjQRVGdaDoTkLT+FRRt5adFZhzrjV+q2s9HyBrR0pdQ=";

  mypy-boto3-greengrassv2 =
    buildMypyBoto3Package "greengrassv2" "1.40.0"
      "sha256-FMt0y3H1PQ8I7VdZvh/spGzluAmfPFEXypcR8zsebdM=";

  mypy-boto3-groundstation =
    buildMypyBoto3Package "groundstation" "1.40.0"
      "sha256-/LlMFYC7cJWb9C5JIt0dTEPtl2sPsalSq7mYaFSf3c4=";

  mypy-boto3-guardduty =
    buildMypyBoto3Package "guardduty" "1.40.5"
      "sha256-yIFysk4ru4Us4azUpGVYim1j8FTQfxw/s0xmZWwSneQ=";

  mypy-boto3-health =
    buildMypyBoto3Package "health" "1.40.0"
      "sha256-c/QCgM8mWIAe76C7e3+g9z3i/ukvOz9QGungofo2hY8=";

  mypy-boto3-healthlake =
    buildMypyBoto3Package "healthlake" "1.40.0"
      "sha256-zsVA9tf4try58FeHrxsVdXxdN9d1UpLiebb6tViGZ3k=";

  mypy-boto3-iam =
    buildMypyBoto3Package "iam" "1.40.0"
      "sha256-uQCsVXN1Qo8LvDeqJP3SkB4ttwGK5E4Kr5nsD4SijUQ=";

  mypy-boto3-identitystore =
    buildMypyBoto3Package "identitystore" "1.40.0"
      "sha256-RLcGOVDiwryD6xf9E6lWSdAAIKCP4hNaBQknjbwPAuQ=";

  mypy-boto3-imagebuilder =
    buildMypyBoto3Package "imagebuilder" "1.40.0"
      "sha256-Mcp5NCJal9YyJ9bQN9q/M0E/pXvXiDlLGvAqpCo2xLs=";

  mypy-boto3-importexport =
    buildMypyBoto3Package "importexport" "1.40.0"
      "sha256-ba01dCNMlcTw/+WrulQkCtDagcPO7FF94cgkY14Pgsg=";

  mypy-boto3-inspector =
    buildMypyBoto3Package "inspector" "1.40.0"
      "sha256-qreFTjlz+Mcr3dcgHGMjfV0GPF2SfE/zV+FN26JHa0A=";

  mypy-boto3-inspector2 =
    buildMypyBoto3Package "inspector2" "1.40.6"
      "sha256-A8fOl2LR+moh+/OAjPY3iufppLaFSxHlwMjxzZbyfOU=";

  mypy-boto3-internetmonitor =
    buildMypyBoto3Package "internetmonitor" "1.40.0"
      "sha256-mZfvKN+x91U1yjBwo4pKZN6jCnUMbl8SnwWF3IMx+ko=";

  mypy-boto3-iot =
    buildMypyBoto3Package "iot" "1.40.0"
      "sha256-0AUK0HaqmoLVbbLDcsagUZX7KkFF9zU7obO0BmcK8+s=";

  mypy-boto3-iot-data =
    buildMypyBoto3Package "iot-data" "1.40.6"
      "sha256-fEw3aD8FGyvuQMmr80Fb9pk/IRXa0ZVHXt5Lptahnoc=";

  mypy-boto3-iot-jobs-data =
    buildMypyBoto3Package "iot-jobs-data" "1.40.0"
      "sha256-NH8dQFWdA5jiZnCFGcfDV1RI/fULth9kI1kNlmV2z8Y=";

  mypy-boto3-iot1click-devices =
    buildMypyBoto3Package "iot1click-devices" "1.35.93"
      "sha256-fwfuhSitYIJW5QswYdZ8ZpNL3AEg6MXhJitbbU48STs=";

  mypy-boto3-iot1click-projects =
    buildMypyBoto3Package "iot1click-projects" "1.35.93"
      "sha256-LFuz5/nCZGpSfgqyswxn80VzxXsqzZlBFqPtPJ8bzgo=";

  mypy-boto3-iotanalytics =
    buildMypyBoto3Package "iotanalytics" "1.40.0"
      "sha256-llbeFHGDeVXv++P6wtIh+lwMbVlNPIpDim7s5Ux4MV8=";

  mypy-boto3-iotdeviceadvisor =
    buildMypyBoto3Package "iotdeviceadvisor" "1.40.0"
      "sha256-mo2XR9wv93818e+usfVTp3m/NbZndY8bSbiTZa+TrSI=";

  mypy-boto3-iotevents =
    buildMypyBoto3Package "iotevents" "1.40.0"
      "sha256-3PlH9KqX9zXYayYoseqio20l34nt34YYrp8Zmu/9yIs=";

  mypy-boto3-iotevents-data =
    buildMypyBoto3Package "iotevents-data" "1.40.0"
      "sha256-sIOK6xeN9S4rW+SIdhdHuHEeu4Z1t9xiBQfgspSJYSc=";

  mypy-boto3-iotfleethub =
    buildMypyBoto3Package "iotfleethub" "1.40.0"
      "sha256-U2nCifkYupb+DcMn8JjPUM+dCROsyyZGukChsaDNROE=";

  mypy-boto3-iotfleetwise =
    buildMypyBoto3Package "iotfleetwise" "1.40.0"
      "sha256-PER1D68w6wBvHUH5CGEn4H1zku92vhcwWDFRpoXZlmg=";

  mypy-boto3-iotsecuretunneling =
    buildMypyBoto3Package "iotsecuretunneling" "1.40.0"
      "sha256-E1l57KrYP3ggjLVj94kzBB85CFF7HtldUMHGZP7aUEo=";

  mypy-boto3-iotsitewise =
    buildMypyBoto3Package "iotsitewise" "1.40.2"
      "sha256-BXLPMwfbqcpaRnAuxrmG4pWUsVFHUW+foMvB1gh5Ye4=";

  mypy-boto3-iotthingsgraph =
    buildMypyBoto3Package "iotthingsgraph" "1.40.0"
      "sha256-0uHWqsERVDW0RYP0fO3TGN/TRGVjf2ShprnuPmpuhUc=";

  mypy-boto3-iottwinmaker =
    buildMypyBoto3Package "iottwinmaker" "1.40.0"
      "sha256-UuQ4NUIV3ofY8/+q1dBm3DprGx//lOqngX+zzQIwvn8=";

  mypy-boto3-iotwireless =
    buildMypyBoto3Package "iotwireless" "1.40.0"
      "sha256-Kj/g5lCH7AgHRlSU6od3O4j1OilposHoDP1hYX4S+fs=";

  mypy-boto3-ivs =
    buildMypyBoto3Package "ivs" "1.40.0"
      "sha256-vZM9rXxrSiJ4l2lJ+hcLtYUws+AczRyxncAKv3vIMMo=";

  mypy-boto3-ivs-realtime =
    buildMypyBoto3Package "ivs-realtime" "1.40.0"
      "sha256-iMzhrZa6xtJWy46V0tBgukqPJiT/cF9BHQmNBtjpjWg=";

  mypy-boto3-ivschat =
    buildMypyBoto3Package "ivschat" "1.40.0"
      "sha256-mtWPF8wmFGLC0PqkKX/UiYT6/VG7FfgrbsqTqRIOgsA=";

  mypy-boto3-kafka =
    buildMypyBoto3Package "kafka" "1.40.0"
      "sha256-6gXpZ/pjG8O2LB7Ct4gC21B/R/32w1lJi1r1tdqkmKo=";

  mypy-boto3-kafkaconnect =
    buildMypyBoto3Package "kafkaconnect" "1.40.0"
      "sha256-4wNbhuNsLwrYemkPuadR6oeaCuSajU5IwCb0En89M3U=";

  mypy-boto3-kendra =
    buildMypyBoto3Package "kendra" "1.40.0"
      "sha256-i5CJ9t2W/EE4/b1jIPqRR3DjIVWSSV/KSYSM+wMc944=";

  mypy-boto3-kendra-ranking =
    buildMypyBoto3Package "kendra-ranking" "1.40.0"
      "sha256-YmPJ9mDsBHBgIDEitoxOPVMJxW4yoLe4gDHCQnaTe/o=";

  mypy-boto3-keyspaces =
    buildMypyBoto3Package "keyspaces" "1.40.0"
      "sha256-7gN03saDdFpMyDzaipHRXtq2qkrrzDcp7xhEjm019WI=";

  mypy-boto3-kinesis =
    buildMypyBoto3Package "kinesis" "1.40.0"
      "sha256-T3T3FeI6jc4GK0D2pPL/ECPOxvQbRSHwvBVnmIOn5o4=";

  mypy-boto3-kinesis-video-archived-media =
    buildMypyBoto3Package "kinesis-video-archived-media" "1.40.0"
      "sha256-ihfxiVg/T3QS4NaL3eE5KB9KqLQO4aUIF76LfIPnOmU=";

  mypy-boto3-kinesis-video-media =
    buildMypyBoto3Package "kinesis-video-media" "1.40.0"
      "sha256-OqHwNMeLo8y1J9ClofZc2b8or9LL9ZW66qIOqnBPE4Q=";

  mypy-boto3-kinesis-video-signaling =
    buildMypyBoto3Package "kinesis-video-signaling" "1.40.0"
      "sha256-+M5DE6Ha6ZT3xRwwfNr6Wk/WZIkOGkEXl89rfWwd7Iw=";

  mypy-boto3-kinesis-video-webrtc-storage =
    buildMypyBoto3Package "kinesis-video-webrtc-storage" "1.40.0"
      "sha256-cnUWkJfPyd7G9ClFFWNXHFwuSqmTcUHwluPBeF4qO8o=";

  mypy-boto3-kinesisanalytics =
    buildMypyBoto3Package "kinesisanalytics" "1.40.0"
      "sha256-92xYlrd3Q31HrOvJ1dOB/F2zM+CyldYvZBYbHZaOtIw=";

  mypy-boto3-kinesisanalyticsv2 =
    buildMypyBoto3Package "kinesisanalyticsv2" "1.40.0"
      "sha256-+TJmy+596jgW2w+sJqvZPyJuODHb+94gCqm3ssjXZH0=";

  mypy-boto3-kinesisvideo =
    buildMypyBoto3Package "kinesisvideo" "1.40.0"
      "sha256-xNN1lEUxbLIsuw1vfY0Hckyz2ozPviITwqj359hycqE=";

  mypy-boto3-kms =
    buildMypyBoto3Package "kms" "1.40.0"
      "sha256-n6tXvgy1xKbgCFW1Ynx0N5gGhLSG2GaTqF+Nf1lKfg8=";

  mypy-boto3-lakeformation =
    buildMypyBoto3Package "lakeformation" "1.40.0"
      "sha256-UvToP81b2XL33qRD3eLTGq5CkQ/oOL1zczX64ibzkLY=";

  mypy-boto3-lambda =
    buildMypyBoto3Package "lambda" "1.40.7"
      "sha256-6L7fA6Z/reXbhh/pAt8GMGQpI1Lu1feF90zQ5ZGUjbk=";

  mypy-boto3-lex-models =
    buildMypyBoto3Package "lex-models" "1.40.0"
      "sha256-OjITjvhbdqBc9CMvaWzyIu+ObFiTF2tfSpsQ93W+sBw=";

  mypy-boto3-lex-runtime =
    buildMypyBoto3Package "lex-runtime" "1.40.0"
      "sha256-doynFbb8iYiH/J7+ORecp8z0/PFJjxlnHcq96+iqHV0=";

  mypy-boto3-lexv2-models =
    buildMypyBoto3Package "lexv2-models" "1.40.0"
      "sha256-FgQalWvHO0Zzisw9CLKIKeNchDh5DMHjos2OIyXto40=";

  mypy-boto3-lexv2-runtime =
    buildMypyBoto3Package "lexv2-runtime" "1.40.0"
      "sha256-h9SwctBQvaiaMXVHaj5tzwsBVlDrEz5GWv9Hn222Ukc=";

  mypy-boto3-license-manager =
    buildMypyBoto3Package "license-manager" "1.40.0"
      "sha256-9Afe020suiP14DlvvGETT+3wlUfPWC3qW+47SAxwHuI=";

  mypy-boto3-license-manager-linux-subscriptions =
    buildMypyBoto3Package "license-manager-linux-subscriptions" "1.40.0"
      "sha256-pfIQS9as02Gm4mHUc3q3gMKRHz+wT/lRKHWUc2ugt1s=";

  mypy-boto3-license-manager-user-subscriptions =
    buildMypyBoto3Package "license-manager-user-subscriptions" "1.40.0"
      "sha256-Skch80b9xDgcLwq2CGrS8xEhKZPEMJGT6qB9f0Z5XwY=";

  mypy-boto3-lightsail =
    buildMypyBoto3Package "lightsail" "1.40.1"
      "sha256-1+1UINrLuBwQrBxgjLWI4xJF7GiQDiHI6OjB6Kkct+Y=";

  mypy-boto3-location =
    buildMypyBoto3Package "location" "1.40.0"
      "sha256-hAUULqVRGPw0Ir0XUyhREqT8C8A99lJEGYn4nAxnW7A=";

  mypy-boto3-logs =
    buildMypyBoto3Package "logs" "1.40.0"
      "sha256-eAZIggxP6MJFOjmoBERDQ1tJafaeo5zlOLpbIiXP1RM=";

  mypy-boto3-lookoutequipment =
    buildMypyBoto3Package "lookoutequipment" "1.40.0"
      "sha256-REAeA7qKwik8cKk9WZoOcG2uZLtFFKr4jTRdAu902bs=";

  mypy-boto3-lookoutmetrics =
    buildMypyBoto3Package "lookoutmetrics" "1.40.0"
      "sha256-DGEK29ev4GQ4vpwqO8iq+t9asJxywHsMk3YuqSrfF3s=";

  mypy-boto3-lookoutvision =
    buildMypyBoto3Package "lookoutvision" "1.40.0"
      "sha256-KPOBiptOCywHx3+Uj6GJvZzVaJ2oEirfQXEbiI6iicE=";

  mypy-boto3-m2 =
    buildMypyBoto3Package "m2" "1.40.0"
      "sha256-d7LurkSzbbXqYJXnOsQtxpcSDnY20O5kASOVZJObt+g=";

  mypy-boto3-machinelearning =
    buildMypyBoto3Package "machinelearning" "1.40.0"
      "sha256-8GUW15hhmTVMHUiEa6G3839Z8O+VUerBYVN7lVEHUjg=";

  mypy-boto3-macie2 =
    buildMypyBoto3Package "macie2" "1.40.0"
      "sha256-YQD3ujd2DtQuygjhJH/bJnxUQ30n1gyUcSMRMIXcjTc=";

  mypy-boto3-managedblockchain =
    buildMypyBoto3Package "managedblockchain" "1.40.0"
      "sha256-1zDaKlR03f23CmBe975XugFBDiVC/1WWayCrDZBnBkY=";

  mypy-boto3-managedblockchain-query =
    buildMypyBoto3Package "managedblockchain-query" "1.40.0"
      "sha256-lw7LeVq/o8RFK9P62vQ7iR+jZfH/OOZY2AirYqDltSw=";

  mypy-boto3-marketplace-catalog =
    buildMypyBoto3Package "marketplace-catalog" "1.40.0"
      "sha256-C33HMjDet8ZhC2CUlr0xkYlLQpIOMKjhbqKw7CPz+Tg=";

  mypy-boto3-marketplace-entitlement =
    buildMypyBoto3Package "marketplace-entitlement" "1.40.0"
      "sha256-tgFgsCuWsIC2AkRcLQ7e4ANb0eTwqfU9N1/XXPReB5I=";

  mypy-boto3-marketplacecommerceanalytics =
    buildMypyBoto3Package "marketplacecommerceanalytics" "1.40.0"
      "sha256-f24JMHKTmfJGygP1zdKqLgo/8muBTz/B0LEt31ZJp+I=";

  mypy-boto3-mediaconnect =
    buildMypyBoto3Package "mediaconnect" "1.40.0"
      "sha256-8EUTmbFAFXO724bxmzxa2RoovG9L6mm1dxbNupbKKRQ=";

  mypy-boto3-mediaconvert =
    buildMypyBoto3Package "mediaconvert" "1.40.0"
      "sha256-DJEU4Ha8jpV/J8UP6emYMjcv9RfZt1njsBPD11q0BUI=";

  mypy-boto3-medialive =
    buildMypyBoto3Package "medialive" "1.40.0"
      "sha256-+2qM6+qeDJnvkvVI+z1EzMfGps7ejjVq4FOxOfEzJdg=";

  mypy-boto3-mediapackage =
    buildMypyBoto3Package "mediapackage" "1.40.0"
      "sha256-J1Njm18w+cm4u901YSBLAGmRp4xehLglFCXmrZYMXEQ=";

  mypy-boto3-mediapackage-vod =
    buildMypyBoto3Package "mediapackage-vod" "1.40.0"
      "sha256-2Y/oFyKN9+k6nbRE3jGuvxPYkG8ts/teruqNbopSn6c=";

  mypy-boto3-mediapackagev2 =
    buildMypyBoto3Package "mediapackagev2" "1.40.0"
      "sha256-NRpCHPEXgFazLRtyvzkztliGFtm2eIq4b1CVNaxIXQ0=";

  mypy-boto3-mediastore =
    buildMypyBoto3Package "mediastore" "1.40.0"
      "sha256-+dq2mYkfUZ8nlcWHQ65ENLLTxxX4X4n4lOniFdqxAXM=";

  mypy-boto3-mediastore-data =
    buildMypyBoto3Package "mediastore-data" "1.40.0"
      "sha256-TAVybHWowAXqfpCUgOe0Lt8l2CZhYqha73PSl/0ZmlE=";

  mypy-boto3-mediatailor =
    buildMypyBoto3Package "mediatailor" "1.40.0"
      "sha256-1uTPx4K0dGJfRPupXqkRKTOifmVzNhDgvaBYPpd0A4c=";

  mypy-boto3-medical-imaging =
    buildMypyBoto3Package "medical-imaging" "1.40.0"
      "sha256-FT2lYxXXUxPssxPqinwIbEj1YEhRTyDZz44LyKr6jCc=";

  mypy-boto3-memorydb =
    buildMypyBoto3Package "memorydb" "1.40.0"
      "sha256-pbtnV+rUtjVXOreQNRYKyKB9ovSwyZWNY08LHaxDCFs=";

  mypy-boto3-meteringmarketplace =
    buildMypyBoto3Package "meteringmarketplace" "1.40.0"
      "sha256-wbPakhKKDtNY6y84jzqJQlP7IiG5QAKQTRsYP/tndV8=";

  mypy-boto3-mgh =
    buildMypyBoto3Package "mgh" "1.40.0"
      "sha256-/LncQEw5kVzE7LcoSgN58zOQU53fRAuN5bIsl/yiJZE=";

  mypy-boto3-mgn =
    buildMypyBoto3Package "mgn" "1.40.0"
      "sha256-XyB7/8zj4pU/+cxqhEf2WMoBoo/J12lOrlL0WD2Nhic=";

  mypy-boto3-migration-hub-refactor-spaces =
    buildMypyBoto3Package "migration-hub-refactor-spaces" "1.40.0"
      "sha256-bpQyqX1kM5G9uRICoPo21pW3EyGh9wDHZskJgaB2qQs=";

  mypy-boto3-migrationhub-config =
    buildMypyBoto3Package "migrationhub-config" "1.40.0"
      "sha256-FqJcoj6TNlwgDopB/qYZj3wjnp7auitvM9HntBwYHz0=";

  mypy-boto3-migrationhuborchestrator =
    buildMypyBoto3Package "migrationhuborchestrator" "1.40.0"
      "sha256-EtOj4OjZBn5M5Q9pU2MaSNwXAVXbtFEZICRn/r+e9OQ=";

  mypy-boto3-migrationhubstrategy =
    buildMypyBoto3Package "migrationhubstrategy" "1.40.0"
      "sha256-G+Kn0K9lI24r/A+KBOE2euh+raKIystZ7uB2k9AD/Zg=";

  mypy-boto3-mq =
    buildMypyBoto3Package "mq" "1.40.0"
      "sha256-ve5QGD9F3ulZ1H2IGMmjHEGsj9+kvcHtNVly334pXIA=";

  mypy-boto3-mturk =
    buildMypyBoto3Package "mturk" "1.40.0"
      "sha256-IonB7ZD70OhJmbS1hGpFIjZGpAeBkfomr+10THJydR4=";

  mypy-boto3-mwaa =
    buildMypyBoto3Package "mwaa" "1.40.0"
      "sha256-w/km0Eq/rEX182tDtxVsFCm3bK2pUr1Fh6ZnsX6thAI=";

  mypy-boto3-neptune =
    buildMypyBoto3Package "neptune" "1.40.0"
      "sha256-8qRxsvdg0NMRgE3/oMqKkWB/E0/lUKM04rOHSeb4/FA=";

  mypy-boto3-neptunedata =
    buildMypyBoto3Package "neptunedata" "1.40.0"
      "sha256-5aD/9ACgD/76bPpbZlqHXn0biTxr9wyiLpTyIdxMKYs=";

  mypy-boto3-network-firewall =
    buildMypyBoto3Package "network-firewall" "1.40.0"
      "sha256-Y+OkCSSh9V4ftggspSrgfgwaRs0bsS0QFTuOH5euxFw=";

  mypy-boto3-networkmanager =
    buildMypyBoto3Package "networkmanager" "1.40.0"
      "sha256-6lhlo52AWSKFBNXKMr2zEZF+uyvtRCHNcE5/qPR8xGs=";

  mypy-boto3-nimble =
    buildMypyBoto3Package "nimble" "1.35.0"
      "sha256-gs9eGyRaZN7Fsl0D5fSqtTiYZ+Exp0s8QW/X8ZR7guA=";

  mypy-boto3-oam =
    buildMypyBoto3Package "oam" "1.40.0"
      "sha256-Db3tb9qhUNtdqKVVgq2Z80wVWCA9g7B8YpqR1FmgleQ=";

  mypy-boto3-omics =
    buildMypyBoto3Package "omics" "1.40.0"
      "sha256-rQDR9czspxeRs84kpSC+tUVeXtAXis6ZCN2qu9IRNmg=";

  mypy-boto3-opensearch =
    buildMypyBoto3Package "opensearch" "1.40.0"
      "sha256-DduRVsWhYZPX+mQAj1j1kA00rilUHKA4SnmehgS4hYU=";

  mypy-boto3-opensearchserverless =
    buildMypyBoto3Package "opensearchserverless" "1.40.4"
      "sha256-nkt68bkNRfKMeO9TJV/P5PGzy8ps4CZpYcF2LmDUs2c=";

  mypy-boto3-opsworks =
    buildMypyBoto3Package "opsworks" "1.40.0"
      "sha256-ZuSVlDalSjVyMGVem02HklbAmDZXJeWnd2GBrMFJKHU=";

  mypy-boto3-opsworkscm =
    buildMypyBoto3Package "opsworkscm" "1.40.0"
      "sha256-JEuEjo0htTuDCZx2nNJK2Zq59oSUqkMf4BrNamerfVk=";

  mypy-boto3-organizations =
    buildMypyBoto3Package "organizations" "1.40.0"
      "sha256-dtA75bnyRx4XPHXVTQ1oERInTjnvkiA1FcHobbQXq+o=";

  mypy-boto3-osis =
    buildMypyBoto3Package "osis" "1.40.0"
      "sha256-UUCzZfdYXlF9OZkDA+BI6tK1pfTuyaAZ9CJQdRna1s8=";

  mypy-boto3-outposts =
    buildMypyBoto3Package "outposts" "1.40.0"
      "sha256-iZ8rz+esBOvQSDwfbF/eaGUWt5Dvfh+lFvCn7XXK4BY=";

  mypy-boto3-panorama =
    buildMypyBoto3Package "panorama" "1.40.0"
      "sha256-KmP7bsUmw3+/ptwGQtLoNpRdHAgxMVjJptVx/y292cQ=";

  mypy-boto3-payment-cryptography =
    buildMypyBoto3Package "payment-cryptography" "1.40.0"
      "sha256-TLCQDRpGN61tRE49LnH3wdi5rl/LV64WO6tDN30+74E=";

  mypy-boto3-payment-cryptography-data =
    buildMypyBoto3Package "payment-cryptography-data" "1.40.0"
      "sha256-qehLjC74V6sgo+VGJLNVbgGO6I9MQTXZP3BtQGCjxtE=";

  mypy-boto3-pca-connector-ad =
    buildMypyBoto3Package "pca-connector-ad" "1.40.0"
      "sha256-6kAZW0V/7XXEGCQl24brFhR3utzZ0Ftg8dTUgRN40iU=";

  mypy-boto3-personalize =
    buildMypyBoto3Package "personalize" "1.40.0"
      "sha256-uCJkg08AHfWeSnMQo9Y9/oGwxb6+p7kAZQbTGszv3Os=";

  mypy-boto3-personalize-events =
    buildMypyBoto3Package "personalize-events" "1.40.0"
      "sha256-mFjiZCTx39BpnVDJkjoHnOKKvctZXoVelDXMG6kznyY=";

  mypy-boto3-personalize-runtime =
    buildMypyBoto3Package "personalize-runtime" "1.40.0"
      "sha256-lcLdLz14tQ3KTUngLTQ4iYOWjJTdquoItqKRBdf4ZqU=";

  mypy-boto3-pi =
    buildMypyBoto3Package "pi" "1.40.0"
      "sha256-cOQUbgRJXVYYlT4Raormux73YtBHOMnTOZu7F9rj9iY=";

  mypy-boto3-pinpoint =
    buildMypyBoto3Package "pinpoint" "1.40.0"
      "sha256-7H0lySCszWZpr7YeyGS0nfUeKZX51vf6ILPtHnltHsA=";

  mypy-boto3-pinpoint-email =
    buildMypyBoto3Package "pinpoint-email" "1.40.0"
      "sha256-jXKgufKeGz07mPq2MBZV4TbKajiXtqDhqMZZ1C3tluU=";

  mypy-boto3-pinpoint-sms-voice =
    buildMypyBoto3Package "pinpoint-sms-voice" "1.40.0"
      "sha256-Io/83KkG+w+JahVEiFX9GmNyT/6H8qBisemmYpRh4fk=";

  mypy-boto3-pinpoint-sms-voice-v2 =
    buildMypyBoto3Package "pinpoint-sms-voice-v2" "1.40.0"
      "sha256-3NLCAmTWnTtOErdhtsnYwvQkR043++Ew0G/vT1HcfZg=";

  mypy-boto3-pipes =
    buildMypyBoto3Package "pipes" "1.40.0"
      "sha256-AY8HH2OrOvscERskVLYOx8c8MQntEEseeVwpN6cJuaY=";

  mypy-boto3-polly =
    buildMypyBoto3Package "polly" "1.40.0"
      "sha256-EGjIAOiEnTMneH5SUPBOiwNwQC2KyNoVvPECmPQsOkk=";

  mypy-boto3-pricing =
    buildMypyBoto3Package "pricing" "1.40.0"
      "sha256-ehbxIVTXjEStw0MUiA0Xmk13VhVf07NnUp3hy/PjUEs=";

  mypy-boto3-privatenetworks =
    buildMypyBoto3Package "privatenetworks" "1.38.0"
      "sha256-T04icQC+XwQZhaAEBWRiqfCUaayXP1szpbLdAG/7t3k=";

  mypy-boto3-proton =
    buildMypyBoto3Package "proton" "1.40.0"
      "sha256-39AZnJrwQups3lYJHM18nmyof92C3xw7Tf8jbwNVZ4g=";

  mypy-boto3-qldb =
    buildMypyBoto3Package "qldb" "1.40.0"
      "sha256-PHQpqhWY8k/HUbqnCafgzhAukaUo91Mir/DszBN8y7Q=";

  mypy-boto3-qldb-session =
    buildMypyBoto3Package "qldb-session" "1.40.0"
      "sha256-8nZ7ZrBh6TbqAMOXD546FBiNtdRhWe/UGXrqeFe15vQ=";

  mypy-boto3-quicksight =
    buildMypyBoto3Package "quicksight" "1.40.7"
      "sha256-scnIRamymMIBSKcHFhxnxDASqjOQvVm9ywAivUYWN6s=";

  mypy-boto3-ram =
    buildMypyBoto3Package "ram" "1.40.0"
      "sha256-8EfTTXMgOylxEKDit+NPXUaS2VmurnOFwz8fBfByz5I=";

  mypy-boto3-rbin =
    buildMypyBoto3Package "rbin" "1.40.0"
      "sha256-1yLtNpzjAZzF2L87OvTsXN7VhwyQt3KA1YpRxPPjNG8=";

  mypy-boto3-rds =
    buildMypyBoto3Package "rds" "1.40.3"
      "sha256-SqXuOk/U9ux5cuzqazNit8ANMmnLimv1/xPYBxymN+Y=";

  mypy-boto3-rds-data =
    buildMypyBoto3Package "rds-data" "1.40.0"
      "sha256-EjuSI3v4i4PRTmcQtqRTRdgfBXBBzF9ChJV9x6VCdtY=";

  mypy-boto3-redshift =
    buildMypyBoto3Package "redshift" "1.40.0"
      "sha256-SDFNBdXoyyc+EZbO44kk1uChO8as3SeYcJvwwPzPYHQ=";

  mypy-boto3-redshift-data =
    buildMypyBoto3Package "redshift-data" "1.40.0"
      "sha256-rJnEK9W8zZ6hxp5YvysRaxk01vaCv3+zpE9GSdRb1jA=";

  mypy-boto3-redshift-serverless =
    buildMypyBoto3Package "redshift-serverless" "1.40.0"
      "sha256-iRj6arzq9rBsbuImlWdStHbs5o5D4f9MowdG5M7w6SA=";

  mypy-boto3-rekognition =
    buildMypyBoto3Package "rekognition" "1.40.0"
      "sha256-uVQIk3XxR7mwd/sY5TQk6jy6m5qzr0pMu/0Q4fItu3U=";

  mypy-boto3-resiliencehub =
    buildMypyBoto3Package "resiliencehub" "1.40.0"
      "sha256-PaBrmTZ/EpFDH94bw/zQqRcLiQrOQlKrIHQgXcuR0Qo=";

  mypy-boto3-resource-explorer-2 =
    buildMypyBoto3Package "resource-explorer-2" "1.40.0"
      "sha256-qlgF3um/4jRBAMsb9Ru7N8sm4VekcBkhSCvJw6S/4Uk=";

  mypy-boto3-resource-groups =
    buildMypyBoto3Package "resource-groups" "1.40.0"
      "sha256-ItxjwhL7oRnh/KWFVsVxX1ayANALBasbEPNe0dBmY5Q=";

  mypy-boto3-resourcegroupstaggingapi =
    buildMypyBoto3Package "resourcegroupstaggingapi" "1.40.0"
      "sha256-NRNWvFj3jb7EdKqUEhGXH2zVetFn+GcdokZJQ6JMsUk=";

  mypy-boto3-robomaker =
    buildMypyBoto3Package "robomaker" "1.40.0"
      "sha256-3Ip7qLa3LCKjoM4duODUt8fA0OCMFCVUvZkmK84TRgs=";

  mypy-boto3-rolesanywhere =
    buildMypyBoto3Package "rolesanywhere" "1.40.0"
      "sha256-9AfMYmfGgFYxbGF1UYLBEtCkmYtlPNtD0q2MHmbJUWw=";

  mypy-boto3-route53 =
    buildMypyBoto3Package "route53" "1.40.0"
      "sha256-7cIfnpdrNUByompkx6sncBpYl/s4pFbwUFmHfvg07Qw=";

  mypy-boto3-route53-recovery-cluster =
    buildMypyBoto3Package "route53-recovery-cluster" "1.40.0"
      "sha256-bl9tBA5QmntHCYMcYhLW8N8w+oTTStr33J5C8kbXnZs=";

  mypy-boto3-route53-recovery-control-config =
    buildMypyBoto3Package "route53-recovery-control-config" "1.40.0"
      "sha256-4o3SPst6sQ91GZsH6JEVjk2PqPc7zUYQpdQxM/Ki3VI=";

  mypy-boto3-route53-recovery-readiness =
    buildMypyBoto3Package "route53-recovery-readiness" "1.40.0"
      "sha256-3H++iwsm7Lhe8rKkyR+IJ0reNeXaL94UEkqfLBKClzY=";

  mypy-boto3-route53domains =
    buildMypyBoto3Package "route53domains" "1.40.0"
      "sha256-DUchDeH+JUHtQNNRgGlWrWic5lHz2VkovlRs4BU2jZ0=";

  mypy-boto3-route53resolver =
    buildMypyBoto3Package "route53resolver" "1.40.0"
      "sha256-wY1ypBS0J/0JvGJ7rc8HL52onwypC0FgkS4Zz6FKqpg=";

  mypy-boto3-rum =
    buildMypyBoto3Package "rum" "1.40.0"
      "sha256-+fgiX8rSj53vuJuuTOX26sipW3xiFDt7ik7r65alHcw=";

  mypy-boto3-s3 =
    buildMypyBoto3Package "s3" "1.40.0"
      "sha256-maSifwTWL+CzEDLydPLhmIn6ZkJEE2F6lBaHPEhWfx0=";

  mypy-boto3-s3control =
    buildMypyBoto3Package "s3control" "1.40.0"
      "sha256-uxxfSEz5FqkZoDeXXGOpZE9BQYxMp9vku9MedXQv7F4=";

  mypy-boto3-s3outposts =
    buildMypyBoto3Package "s3outposts" "1.40.0"
      "sha256-WRLXguy8jlRl+jw472aPmJXdcZg1mPZ/dfhETIVNLiU=";

  mypy-boto3-sagemaker =
    buildMypyBoto3Package "sagemaker" "1.40.6"
      "sha256-PHYCA7VtB8r1HSzvXA+MLgbn72fewbpGtXj+zY1D4Co=";

  mypy-boto3-sagemaker-a2i-runtime =
    buildMypyBoto3Package "sagemaker-a2i-runtime" "1.40.0"
      "sha256-vHiULaXt7b1F2lHx9WXtYr3MnxyDaWDKiozYRTSmkfM=";

  mypy-boto3-sagemaker-edge =
    buildMypyBoto3Package "sagemaker-edge" "1.40.0"
      "sha256-yvZGGSA7RDJm5fOWuOSeyRqz5rpE0E0b4r8nZCVt6Yo=";

  mypy-boto3-sagemaker-featurestore-runtime =
    buildMypyBoto3Package "sagemaker-featurestore-runtime" "1.40.0"
      "sha256-Cw9b4qPE2cPyHovEP7Bs5/uOF7p6O+Kv4B5ORStjQh0=";

  mypy-boto3-sagemaker-geospatial =
    buildMypyBoto3Package "sagemaker-geospatial" "1.40.0"
      "sha256-PHz//7ffPnSUAdLUj5CzjtbJ4XYvXY8/7hi/7HZ4RWg=";

  mypy-boto3-sagemaker-metrics =
    buildMypyBoto3Package "sagemaker-metrics" "1.40.0"
      "sha256-ad7DooARgF8aOpOkvMnUig/zHHARPZe8Y6fkervBGUU=";

  mypy-boto3-sagemaker-runtime =
    buildMypyBoto3Package "sagemaker-runtime" "1.40.0"
      "sha256-gorL6w+a2l5yrVGBy+zOlINjmH77BdymsIxj8YWYio0=";

  mypy-boto3-savingsplans =
    buildMypyBoto3Package "savingsplans" "1.40.0"
      "sha256-vQd3KGj5w2IjbtYfizG0AABF66F7z944YaR156x+YSE=";

  mypy-boto3-scheduler =
    buildMypyBoto3Package "scheduler" "1.40.0"
      "sha256-4JiG6nl/1abDXKRbttHVccrsHZPCNq8LJJT0cVyZNEY=";

  mypy-boto3-schemas =
    buildMypyBoto3Package "schemas" "1.40.0"
      "sha256-yCwPEwRi/DBGNQrMbOce2mTIuIRuRh227h4JOsU2kp8=";

  mypy-boto3-sdb =
    buildMypyBoto3Package "sdb" "1.40.0"
      "sha256-0Ih/hjzLE+pf9dXfTHLli5PYAyRGOTq5ghxNcpMN0RA=";

  mypy-boto3-secretsmanager =
    buildMypyBoto3Package "secretsmanager" "1.40.0"
      "sha256-9lCTZdXU/jJgcDutzvWhxFRV7UVOXwPzVzpQI8wXZkQ=";

  mypy-boto3-securityhub =
    buildMypyBoto3Package "securityhub" "1.40.1"
      "sha256-wNGHpSbcxVrb4UYCLDQHJKZ0+2qB7PKaBM9GSN9dF/k=";

  mypy-boto3-securitylake =
    buildMypyBoto3Package "securitylake" "1.40.0"
      "sha256-DrmDjFx8N9pqL2tikWd1PD0qvBX2oI2Y9+WiDvAlOgE=";

  mypy-boto3-serverlessrepo =
    buildMypyBoto3Package "serverlessrepo" "1.40.0"
      "sha256-E5QNOEIq54TLCtsqCZg1mIFVnk7/kzvLf/K9vhuOzMY=";

  mypy-boto3-service-quotas =
    buildMypyBoto3Package "service-quotas" "1.40.0"
      "sha256-ZQlzItKRMNpMjBDsMdYXeZxc53GA4ODsYXT8Q/RfR7U=";

  mypy-boto3-servicecatalog =
    buildMypyBoto3Package "servicecatalog" "1.40.0"
      "sha256-NQpBAN1iSAgS0TcKWe8GURwxKVdjmslcfkpF8rEL3G4=";

  mypy-boto3-servicecatalog-appregistry =
    buildMypyBoto3Package "servicecatalog-appregistry" "1.40.0"
      "sha256-ET2prHzHi0EBkWB9MlmdudaaJhay5in5+rdUF0T6veE=";

  mypy-boto3-servicediscovery =
    buildMypyBoto3Package "servicediscovery" "1.40.0"
      "sha256-hg/KQ7V0ej2jmLLYLmBChuxZ4IvKypMWAOs6j5zRoYY=";

  mypy-boto3-ses =
    buildMypyBoto3Package "ses" "1.40.0"
      "sha256-q6wRcmrtA0Jb1a04ImKJF0rBMF+dI7CgmIL9SZo27B0=";

  mypy-boto3-sesv2 =
    buildMypyBoto3Package "sesv2" "1.40.0"
      "sha256-aGK44+fTKwT+5o4bcqz1GvOm/9gpP3oX82Eta/uXc8w=";

  mypy-boto3-shield =
    buildMypyBoto3Package "shield" "1.40.0"
      "sha256-nwgaSaqi1PebG4PEco7o6J0bX28+NpVbYiA+SXk2Or8=";

  mypy-boto3-signer =
    buildMypyBoto3Package "signer" "1.40.0"
      "sha256-S77EdSxEfJn5CzxzBWjxzSY1zttBnS/pPQ2NWKFQM6k=";

  mypy-boto3-simspaceweaver =
    buildMypyBoto3Package "simspaceweaver" "1.40.0"
      "sha256-iPQ4dCw/XZJtUdru+Xmd7t6UaG2HJspWSkL7I/+WdZ4=";

  mypy-boto3-sms =
    buildMypyBoto3Package "sms" "1.40.0"
      "sha256-ZVrH3luEpHwORa+1LNdmgju3+JUy9/F6ghNzHZUicBc=";

  mypy-boto3-sms-voice =
    buildMypyBoto3Package "sms-voice" "1.38.0"
      "sha256-qWnTJxM1h3pmY2PnI8PjT7u4+xODrSQM41IK8QsJCfM=";

  mypy-boto3-snow-device-management =
    buildMypyBoto3Package "snow-device-management" "1.40.0"
      "sha256-nz8mCT3F3TnU/SmO9BAyJ/Q0/ghxUhTZCgHsXHaX8+M=";

  mypy-boto3-snowball =
    buildMypyBoto3Package "snowball" "1.40.0"
      "sha256-7UFz5HOt4iKYrd25ODXrrs6OI4bMZbxS7uE++psmn5U=";

  mypy-boto3-sns =
    buildMypyBoto3Package "sns" "1.40.1"
      "sha256-4G2J2xDIM2QJY2XGMKFE1Zyj4P22Y7vWtzvRgW0eU9s=";

  mypy-boto3-sqs =
    buildMypyBoto3Package "sqs" "1.40.0"
      "sha256-A9C1tIjj0B8kGUALokXde4m74GpDil1PWdNY7urRm7Q=";

  mypy-boto3-ssm =
    buildMypyBoto3Package "ssm" "1.40.0"
      "sha256-SmViQOrSn/z7KOlc58erbJu61xu+fOgfMo/5shT/EUs=";

  mypy-boto3-ssm-contacts =
    buildMypyBoto3Package "ssm-contacts" "1.40.0"
      "sha256-QUWxj3Yz4+Vi9t3J2f0DCHL/RG/VbJnIqC4BUT9AmOk=";

  mypy-boto3-ssm-incidents =
    buildMypyBoto3Package "ssm-incidents" "1.40.0"
      "sha256-EX4a0R3N6pWZpybsRofvsZ7Z5eQCu7eczEOHyr2S+h4=";

  mypy-boto3-ssm-sap =
    buildMypyBoto3Package "ssm-sap" "1.40.0"
      "sha256-4LZCntV/BRG+/Y6/hWPgeuFP7anx7HjsC1OMHZXgg+0=";

  mypy-boto3-sso =
    buildMypyBoto3Package "sso" "1.40.0"
      "sha256-I//h5aZulOxyEz6X4NQc+rlbKhfnoJodbNWlsFVPtF4=";

  mypy-boto3-sso-admin =
    buildMypyBoto3Package "sso-admin" "1.40.7"
      "sha256-aate7wrDPC/Gvgu1mdFDaVz24QpFMwsThicGf41b7qI=";

  mypy-boto3-sso-oidc =
    buildMypyBoto3Package "sso-oidc" "1.40.0"
      "sha256-lrGga9jxuUUL+71vzkDD0HKVxEu8wIo9YHiF45u8loU=";

  mypy-boto3-stepfunctions =
    buildMypyBoto3Package "stepfunctions" "1.40.0"
      "sha256-t+4xYTbTLkXRoDyteBCVljSb3v2P/sBLLEUmpQm6U80=";

  mypy-boto3-storagegateway =
    buildMypyBoto3Package "storagegateway" "1.40.0"
      "sha256-LwQqfbpqRaGyridCiI73LjQjsQn+h6Gc2HDt3AKt8dI=";

  mypy-boto3-sts =
    buildMypyBoto3Package "sts" "1.40.0"
      "sha256-61XlCWCuYZTQlIhGTDAhljkt9xKmpfQwi2oOJCRM/Vw=";

  mypy-boto3-support =
    buildMypyBoto3Package "support" "1.40.0"
      "sha256-kNDyeCMDOf4pV5P3dMsKotAMrBVR+Dct8abMT7eHnDI=";

  mypy-boto3-support-app =
    buildMypyBoto3Package "support-app" "1.40.0"
      "sha256-+yxtP/cnx2CiQUs5IW5kibeGStP0MFXGFpRy7M2uKt0=";

  mypy-boto3-swf =
    buildMypyBoto3Package "swf" "1.40.0"
      "sha256-qkE3rF32WkR56WB5pu3dKJLCLY5e1rvMDPYAruyj9O8=";

  mypy-boto3-synthetics =
    buildMypyBoto3Package "synthetics" "1.40.0"
      "sha256-LCW7HDnLI4BurauxCef8W93Rt/NYjR3XM1gC6AQ9uuA=";

  mypy-boto3-textract =
    buildMypyBoto3Package "textract" "1.40.0"
      "sha256-hMLxKQ6aMwdquw2oOgeB33OigX25MOQFJhGEBfEyf7U=";

  mypy-boto3-timestream-query =
    buildMypyBoto3Package "timestream-query" "1.40.0"
      "sha256-lhLcDJRzRC1F22EtoZZaG5tXh8gs7xCnfU6GHb2O7bA=";

  mypy-boto3-timestream-write =
    buildMypyBoto3Package "timestream-write" "1.40.0"
      "sha256-fFnOLkdkLqQKlbavE4eHCXHYzoIZUhjyQwNrsCXarjk=";

  mypy-boto3-tnb =
    buildMypyBoto3Package "tnb" "1.40.0"
      "sha256-SfZ4sYKJic9iQfWxUQEdV233Y5NbITHWjC3Vt+hFpHA=";

  mypy-boto3-transcribe =
    buildMypyBoto3Package "transcribe" "1.40.6"
      "sha256-4wI5o8vjyrVpHn4P4e8J/EshhuqioqAQqkB3qdJr5hE=";

  mypy-boto3-transfer =
    buildMypyBoto3Package "transfer" "1.40.0"
      "sha256-BMsYO2mBrK/CtWRj9jVNO2sC4IarhQ+1hYd9FeJDIEw=";

  mypy-boto3-translate =
    buildMypyBoto3Package "translate" "1.40.0"
      "sha256-r0WubEtRpiEWHNHqh5aPKD77TA9OLlDQiZHN3tRVTcU=";

  mypy-boto3-verifiedpermissions =
    buildMypyBoto3Package "verifiedpermissions" "1.40.0"
      "sha256-u7f3iDh6jCFYWUdQThLrFJQO1d/3GqiP8IFAOGO627s=";

  mypy-boto3-voice-id =
    buildMypyBoto3Package "voice-id" "1.40.0"
      "sha256-jSYghl70WSRHGCEhmhVveKTpN93y2JWtlXTBqdHgfg0=";

  mypy-boto3-vpc-lattice =
    buildMypyBoto3Package "vpc-lattice" "1.40.0"
      "sha256-I2rPZoC+WSv7qNHD/UKqeACtX11wyse4CKBFy7hoBfI=";

  mypy-boto3-waf =
    buildMypyBoto3Package "waf" "1.40.0"
      "sha256-OTU77sd04w1esOd5pEN6X2faLVkJK/08J9SpURLEe1Y=";

  mypy-boto3-waf-regional =
    buildMypyBoto3Package "waf-regional" "1.40.0"
      "sha256-BCmGOUKfRbzFczLKiU5gMjnU3RALOFIHmif2peyzggY=";

  mypy-boto3-wafv2 =
    buildMypyBoto3Package "wafv2" "1.40.0"
      "sha256-o1Vz6xyFHZXg6/hTEf+uO3LCVlZjgDBKI5V9hCedAPc=";

  mypy-boto3-wellarchitected =
    buildMypyBoto3Package "wellarchitected" "1.40.0"
      "sha256-NCsDTXA3eGZAhrTU/G8zgEVQT9Z8ZIH33voql8t2P6U=";

  mypy-boto3-wisdom =
    buildMypyBoto3Package "wisdom" "1.40.0"
      "sha256-B+hgPZPqVl2YpsBxmkVph+L9lMv7PzJAevqMEXHAXSQ=";

  mypy-boto3-workdocs =
    buildMypyBoto3Package "workdocs" "1.40.0"
      "sha256-IKalgYiSeDGbexPrEiF9SA09iA2axZmjqfpjD2k1GnE=";

  mypy-boto3-worklink =
    buildMypyBoto3Package "worklink" "1.35.0"
      "sha256-AgK4Xg1dloJmA+h4+mcBQQVTvYKjLCk5tPDbl/ItCVQ=";

  mypy-boto3-workmail =
    buildMypyBoto3Package "workmail" "1.40.0"
      "sha256-uASXlvIjlvxapMkuNwzwmxu0rWiwRnmtRutCKBBkRNM=";

  mypy-boto3-workmailmessageflow =
    buildMypyBoto3Package "workmailmessageflow" "1.40.0"
      "sha256-zApXRQ+MpzmwpQcghnoC34FaKlLQ/g8kZZUwbU0G8p8=";

  mypy-boto3-workspaces =
    buildMypyBoto3Package "workspaces" "1.40.0"
      "sha256-LRf2JH9+Z+a1yX1TodO6ASUFY7+Ct9RLu2BS0CF3X0U=";

  mypy-boto3-workspaces-web =
    buildMypyBoto3Package "workspaces-web" "1.40.0"
      "sha256-1Nm+3yAqMg/qtpdxae2etPehfszBq454U/U/1ClPeGg=";

  mypy-boto3-xray =
    buildMypyBoto3Package "xray" "1.40.0"
      "sha256-aOpynDPYP98n+TQcnMNZ1y1ozDkZ5AtQMr4dkLVIarI=";
}
