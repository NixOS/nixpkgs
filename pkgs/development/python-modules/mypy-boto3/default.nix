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
{
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
    buildMypyBoto3Package "acm-pca" "1.40.54"
      "sha256-MqxsI64KEyipR0iiaifc42HQLHsVIFMmtvN2/Vx1EJU=";

  mypy-boto3-amp =
    buildMypyBoto3Package "amp" "1.40.29"
      "sha256-LHVI54tJakPFTh0l+YZMJQV9X6+smUNJBee0u8WO5ro=";

  mypy-boto3-amplify =
    buildMypyBoto3Package "amplify" "1.40.54"
      "sha256-8nNBUlGXVoracAltiBNWohK7yG8z6Q0KGupyOS9/Tpc=";

  mypy-boto3-amplifybackend =
    buildMypyBoto3Package "amplifybackend" "1.40.19"
      "sha256-XxeDxB9uvOSFDPrnuSGHYhuAY9m9WrGX+j0I2IQ2Cnw=";

  mypy-boto3-amplifyuibuilder =
    buildMypyBoto3Package "amplifyuibuilder" "1.40.0"
      "sha256-wBdq3kI0El1XZRuGMG2lN0Zjc1GIBOItMBvctF/10Wg=";

  mypy-boto3-apigateway =
    buildMypyBoto3Package "apigateway" "1.40.0"
      "sha256-mfMTQ3XSVHDjTjQEY/EL1xq4t0KRaPwG2Nu0Pwsbk3o=";

  mypy-boto3-apigatewaymanagementapi =
    buildMypyBoto3Package "apigatewaymanagementapi" "1.40.54"
      "sha256-/818ZgAE2Pqwcr914QvY86R5joOZ8kjM6StO4EpobdM=";

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
    buildMypyBoto3Package "appfabric" "1.40.15"
      "sha256-wLCPBODUaTw6VdnbZ0bD9BzIVTPuGpVlZfeGBZY95B8=";

  mypy-boto3-appflow =
    buildMypyBoto3Package "appflow" "1.40.17"
      "sha256-eBbaAv0NU/VcaZNNPaBvU2pt7rXNm2DwqZ0xtoX2WwU=";

  mypy-boto3-appintegrations =
    buildMypyBoto3Package "appintegrations" "1.40.0"
      "sha256-7su8sPB0QUQi+5ZQd701JYNVqpoIww3q0N4puBcszT4=";

  mypy-boto3-application-autoscaling =
    buildMypyBoto3Package "application-autoscaling" "1.40.0"
      "sha256-XMvGnZjdb8sQ8QES1CkZD7VkditEdudUGPVaYwF25Fk=";

  mypy-boto3-application-insights =
    buildMypyBoto3Package "application-insights" "1.40.19"
      "sha256-UNaLgX1dogngrhDFGhVi4FC4mAhkH2dW+Sk/4sAPh9M=";

  mypy-boto3-applicationcostprofiler =
    buildMypyBoto3Package "applicationcostprofiler" "1.40.20"
      "sha256-owSt/dJ4jtYwAjvi7/gKHqdn9ZdlXrdVggeqP09/GI8=";

  mypy-boto3-appmesh =
    buildMypyBoto3Package "appmesh" "1.40.0"
      "sha256-ZMDdjJse4uyAnWIy/cwQQuAemTrUBdm8PYQp0LTuHgE=";

  mypy-boto3-apprunner =
    buildMypyBoto3Package "apprunner" "1.40.54"
      "sha256-t4mGNhPOii3GcMirgyvGZ53XmYf+GpWwMkL0RELswrs=";

  mypy-boto3-appstream =
    buildMypyBoto3Package "appstream" "1.40.52"
      "sha256-l1Zrigv4T4W9z+9MrZTTcTeeVISb5wnjepBpfSv554g=";

  mypy-boto3-appsync =
    buildMypyBoto3Package "appsync" "1.40.0"
      "sha256-NgOa+Na/gU7IrtEJ8bVMJaSCNgTnGreX2TsjsAlIN+Y=";

  mypy-boto3-arc-zonal-shift =
    buildMypyBoto3Package "arc-zonal-shift" "1.40.18"
      "sha256-+CR5RYb8rFZxC5Vl208nRf9RT0Dhd7w1s0vdkefAhM4=";

  mypy-boto3-athena =
    buildMypyBoto3Package "athena" "1.40.0"
      "sha256-2oQp9Va82Feyyf7ZEz7wv+y4mOK3TpZ586qvzCZwK/E=";

  mypy-boto3-auditmanager =
    buildMypyBoto3Package "auditmanager" "1.40.1"
      "sha256-p8jnTJigD8QuLe3vjZwE7ZyGgBblpSdM0II0Cr/xFS8=";

  mypy-boto3-autoscaling =
    buildMypyBoto3Package "autoscaling" "1.40.27"
      "sha256-lnejEICkgHqQWfiN3LyNIHzDjfpgP2GlAr6acRP/wFo=";

  mypy-boto3-autoscaling-plans =
    buildMypyBoto3Package "autoscaling-plans" "1.40.54"
      "sha256-pSEyo/Bpim0PgH0tj+MbJUIYwLk23M0mAh3LbTMv8m8=";

  mypy-boto3-backup =
    buildMypyBoto3Package "backup" "1.40.52"
      "sha256-bo+tgMbUCf1uL8fNB/5UBgUtIiYMMQpd/uaj/LUuZ6U=";

  mypy-boto3-backup-gateway =
    buildMypyBoto3Package "backup-gateway" "1.40.15"
      "sha256-BZXrWhqf5gFrTW0fAsiyiydzc0cTv2lPj5DTRLrv+pI=";

  mypy-boto3-batch =
    buildMypyBoto3Package "batch" "1.40.54"
      "sha256-iIQwIdK4dqKCDwxmeL7mzX/LZFKztIv59LzNuqHc3BU=";

  mypy-boto3-billingconductor =
    buildMypyBoto3Package "billingconductor" "1.40.54"
      "sha256-gikBABSlCcQfBSh8jyIYdN7iyTncBRZoVPQ1UnVbwRU=";

  mypy-boto3-braket =
    buildMypyBoto3Package "braket" "1.40.9"
      "sha256-IUf8vnKJRqa5BeEIKEfAc09ixEIvVRfKBi6nEP1KjZU=";

  mypy-boto3-budgets =
    buildMypyBoto3Package "budgets" "1.40.34"
      "sha256-UzM2sg9jxU/kU6kmMizVJwYLqq+nrZi+D6GLHYPdmJQ=";

  mypy-boto3-ce =
    buildMypyBoto3Package "ce" "1.40.40"
      "sha256-ygUnU/oDBQPqmRfZ6jKMnvVXdORQkBuC57UyXjV6Xi0=";

  mypy-boto3-chime =
    buildMypyBoto3Package "chime" "1.40.19"
      "sha256-j90U6EWrV/zhn0KTitm4/WMV8xh+wm4yjKWFaQ0C4UA=";

  mypy-boto3-chime-sdk-identity =
    buildMypyBoto3Package "chime-sdk-identity" "1.40.19"
      "sha256-coS/9S9Sa2rAZAQPEMDTrZNNyj66jok08bNHpypO2G0=";

  mypy-boto3-chime-sdk-media-pipelines =
    buildMypyBoto3Package "chime-sdk-media-pipelines" "1.40.17"
      "sha256-5qaK+piVZhvHqBJgGteNsvmMZG5y6fvLD4W8qASfcL0=";

  mypy-boto3-chime-sdk-meetings =
    buildMypyBoto3Package "chime-sdk-meetings" "1.40.43"
      "sha256-vhWKoKhIJbB9Em7EA1IMdrSUTBFIgkAOxrdAeepCjbg=";

  mypy-boto3-chime-sdk-messaging =
    buildMypyBoto3Package "chime-sdk-messaging" "1.40.34"
      "sha256-knAtab953lppnI8SioY6V3nMN6pt/l5p4XEsE3CpDGc=";

  mypy-boto3-chime-sdk-voice =
    buildMypyBoto3Package "chime-sdk-voice" "1.40.42"
      "sha256-axa2niA9HlLpV9Tf01p0fG2GhK2lNlCM/O8LLPHQVRc=";

  mypy-boto3-cleanrooms =
    buildMypyBoto3Package "cleanrooms" "1.40.45"
      "sha256-a4FbYJ7O9YpOfT90vAZdxmDDdDHsITCwLjNSAeYtrco=";

  mypy-boto3-cloud9 =
    buildMypyBoto3Package "cloud9" "1.40.20"
      "sha256-zmouqL+B2KyYC1dgmlJBODK3iOftfvFmKCSTUB+paWU=";

  mypy-boto3-cloudcontrol =
    buildMypyBoto3Package "cloudcontrol" "1.40.0"
      "sha256-38IFJI1enFd6XnWe81zuf80N23Orfl1CUCRt57g0zEE=";

  mypy-boto3-clouddirectory =
    buildMypyBoto3Package "clouddirectory" "1.40.16"
      "sha256-fFnHwgB8r239cpVnWSfeiGO1MNOxkXn9MNMUA5ohm04=";

  mypy-boto3-cloudformation =
    buildMypyBoto3Package "cloudformation" "1.40.44"
      "sha256-PYL1UEOCyGrRlaG4CiqC9zWHw34bY2hk67hd1DvXmls=";

  mypy-boto3-cloudfront =
    buildMypyBoto3Package "cloudfront" "1.40.50"
      "sha256-jw169fraZHj0tHiu8ZJTqLu/FrBWVBnePNvtp6V3UUs=";

  mypy-boto3-cloudhsm =
    buildMypyBoto3Package "cloudhsm" "1.40.15"
      "sha256-qr7Okanc/7cgrb31a6mxb23S8nvw3iztCcbGNHcMIhk=";

  mypy-boto3-cloudhsmv2 =
    buildMypyBoto3Package "cloudhsmv2" "1.40.20"
      "sha256-t5daUK4Nv1R+9uvRYdbOvDWP77A1GhH34w4XkCdIkb0=";

  mypy-boto3-cloudsearch =
    buildMypyBoto3Package "cloudsearch" "1.40.17"
      "sha256-bnLdoUOM0daHl74qUUfv6RO6Mqkk8Su97RzCjKettQQ=";

  mypy-boto3-cloudsearchdomain =
    buildMypyBoto3Package "cloudsearchdomain" "1.40.20"
      "sha256-a+XyFwXb5YGI9/Z5+Qh5TOfJssHJR6j8oJNwl47sObA=";

  mypy-boto3-cloudtrail =
    buildMypyBoto3Package "cloudtrail" "1.40.0"
      "sha256-aV+fpcURVMZv7jOsZ/LF6edo4doNZPtCwdG4YEGKMYc=";

  mypy-boto3-cloudtrail-data =
    buildMypyBoto3Package "cloudtrail-data" "1.40.17"
      "sha256-ghgArlI9Z/rk9kM6k6b+0x/Fugp7q25+uV+Y2dZFtSU=";

  mypy-boto3-cloudwatch =
    buildMypyBoto3Package "cloudwatch" "1.40.38"
      "sha256-JCKTfyeEvYsw8b2EOGJVh+Y6lgpzMFecj2y35o3K9Mo=";

  mypy-boto3-codeartifact =
    buildMypyBoto3Package "codeartifact" "1.40.17"
      "sha256-XqaCY0uawL5BKmcTl1D3uz1EgsKn3wtph036TX07/Fg=";

  mypy-boto3-codebuild =
    buildMypyBoto3Package "codebuild" "1.40.8"
      "sha256-D3uNdpK45WYJfwf1mr12+e+7uw0dj7ChCmSDel0cNw4=";

  mypy-boto3-codecatalyst =
    buildMypyBoto3Package "codecatalyst" "1.40.0"
      "sha256-cPLylCvda6iHWRcPMVaL/qEkeg7EzBs38G2mX1eP0ZI=";

  mypy-boto3-codecommit =
    buildMypyBoto3Package "codecommit" "1.40.18"
      "sha256-+T9NGuE7gN1OjOBhIU8QCo09FiAQ1qdiABitoQpDZrk=";

  mypy-boto3-codedeploy =
    buildMypyBoto3Package "codedeploy" "1.40.20"
      "sha256-1YBZlgDBAmYmkSgI0BGWAlyDGwSEjISd+NDqk2PPlbI=";

  mypy-boto3-codeguru-reviewer =
    buildMypyBoto3Package "codeguru-reviewer" "1.40.20"
      "sha256-ijOEA6FwLfHIUa+Tt6OQek7oJ4bJf4tRG+Q2QeIh1Rk=";

  mypy-boto3-codeguru-security =
    buildMypyBoto3Package "codeguru-security" "1.40.17"
      "sha256-LT2Fi8LHrgRgYz6HnKyRB14Vl+PjCjTx/EF8s5D2hhw=";

  mypy-boto3-codeguruprofiler =
    buildMypyBoto3Package "codeguruprofiler" "1.40.19"
      "sha256-hQ2gveiEQoG4pVqOGDs7eOFCuVaPbyACErsmQxfWo3I=";

  mypy-boto3-codepipeline =
    buildMypyBoto3Package "codepipeline" "1.40.0"
      "sha256-wWJVXhlaRSBmDs0rA+Uqa36yBShPzUqFYB7qkkTCteg=";

  mypy-boto3-codestar =
    buildMypyBoto3Package "codestar" "1.35.0"
      "sha256-B9Aq+hh9BOzCIYMkS21IZYb3tNCnKnV2OpSIo48aeJM=";

  mypy-boto3-codestar-connections =
    buildMypyBoto3Package "codestar-connections" "1.40.18"
      "sha256-NNVGx+fN0apfT84GbtQjK6YX30bIomIPUaK9RFOsrVQ=";

  mypy-boto3-codestar-notifications =
    buildMypyBoto3Package "codestar-notifications" "1.40.17"
      "sha256-uzTn5MwCM6dkY5P9/tLfZqOfdKVvBClMxMkG9vgnx/4=";

  mypy-boto3-cognito-identity =
    buildMypyBoto3Package "cognito-identity" "1.40.15"
      "sha256-dcRx6MHTZl2tdroNAqvkTtj74tbMULAlw5pkWs57NOk=";

  mypy-boto3-cognito-idp =
    buildMypyBoto3Package "cognito-idp" "1.40.14"
      "sha256-g79jptfBbK/WuUeQDMnEogENZ0ysf1UKfMFa1fzlWkU=";

  mypy-boto3-cognito-sync =
    buildMypyBoto3Package "cognito-sync" "1.40.16"
      "sha256-NFaYYsnZD0MlDKl7t9FCMLV2eo/WH34ach4o6N/xrm0=";

  mypy-boto3-comprehend =
    buildMypyBoto3Package "comprehend" "1.40.15"
      "sha256-8lrg38NrNjdyZ/8qKsD1glKqnzrwPvkQ1RAk3qiCi3Q=";

  mypy-boto3-comprehendmedical =
    buildMypyBoto3Package "comprehendmedical" "1.40.18"
      "sha256-z/pN67x0vam1aGd+24ZJHSdOp04A/Di179ymtUw/61Q=";

  mypy-boto3-compute-optimizer =
    buildMypyBoto3Package "compute-optimizer" "1.40.0"
      "sha256-CSfC9Kg73LydRU5aH4kqdc0pJWqEf98ebu6FOBE7oVU=";

  mypy-boto3-config =
    buildMypyBoto3Package "config" "1.40.35"
      "sha256-MIxmEy+/mlDwWKpHrb0jo8Yu1C7+xP6JRNvUeDmlfZ0=";

  mypy-boto3-connect =
    buildMypyBoto3Package "connect" "1.40.52"
      "sha256-Y4inB+VA4aWEsef389vf2K0K6uvGxsAugtetxnKCSfU=";

  mypy-boto3-connect-contact-lens =
    buildMypyBoto3Package "connect-contact-lens" "1.40.0"
      "sha256-sRuNGX0Xy9sQmHpWZtjbMYTSFgAzTAuNke4uHINz9q8=";

  mypy-boto3-connectcampaigns =
    buildMypyBoto3Package "connectcampaigns" "1.40.0"
      "sha256-nAOKVy+aH2gw8NZ8cNSYqQ0kFWV4Gb4oU6y1vHz3fpI=";

  mypy-boto3-connectcases =
    buildMypyBoto3Package "connectcases" "1.40.44"
      "sha256-T4E5rin+Y0DJWARRqzA7agLwcF11v4CGy/Fe/x/F7vY=";

  mypy-boto3-connectparticipant =
    buildMypyBoto3Package "connectparticipant" "1.40.18"
      "sha256-FT+D1wlBL1dYus9PuLPxIxhj17WCg1nYqzT3dUn32+g=";

  mypy-boto3-controltower =
    buildMypyBoto3Package "controltower" "1.40.0"
      "sha256-boRrDWiYtyKWUimJ7yb3uYPGSB/tmI2sEXNFacAPDic=";

  mypy-boto3-cur =
    buildMypyBoto3Package "cur" "1.40.17"
      "sha256-QRwEUkDj7S0/VuQrcwuPWqKnzXEN6NYUSakhT+9T2wk=";

  mypy-boto3-customer-profiles =
    buildMypyBoto3Package "customer-profiles" "1.40.54"
      "sha256-mbbRVnRyCe97wfrWg5glIWmxx9czOCmJC4OrUVYRnYI=";

  mypy-boto3-databrew =
    buildMypyBoto3Package "databrew" "1.40.54"
      "sha256-x9YaYbLf/qq9OGLs2jhjap7TbgK8+HmADcnu+szrxvE=";

  mypy-boto3-dataexchange =
    buildMypyBoto3Package "dataexchange" "1.40.54"
      "sha256-iyXEvp4dra76CPor7FK8xsZ4zVojFv1+IcmAKlXcB7k=";

  mypy-boto3-datapipeline =
    buildMypyBoto3Package "datapipeline" "1.40.19"
      "sha256-VBJsQqd5m5RfO+tJklYHd+pk2zqpqyDXO4BmRGdFxS4=";

  mypy-boto3-datasync =
    buildMypyBoto3Package "datasync" "1.40.42"
      "sha256-utMenSLve20f+TKyA5xeoAGTEPlizo7uQJSEKt2gq68=";

  mypy-boto3-dax =
    buildMypyBoto3Package "dax" "1.40.38"
      "sha256-jzNdzI1E16m8/5XdD4nKVfyYFbisU5Kc59+0Ei+cnDo=";

  mypy-boto3-detective =
    buildMypyBoto3Package "detective" "1.40.14"
      "sha256-QDNLIgNekgueP8XNyBbRpT1NbD+ZwxQ2OzWU4aF9/GM=";

  mypy-boto3-devicefarm =
    buildMypyBoto3Package "devicefarm" "1.40.0"
      "sha256-6v65flOExW7V8UfoyPaBcUQDYjhJ2jyuQpXMZW+ajCI=";

  mypy-boto3-devops-guru =
    buildMypyBoto3Package "devops-guru" "1.40.17"
      "sha256-cDV8kPjBB3Mu5cqsAVsRjTk6KMozwEMHx/Fu0SRp5EQ=";

  mypy-boto3-directconnect =
    buildMypyBoto3Package "directconnect" "1.40.10"
      "sha256-ZM9nCSSzMmRjyxnypQcaORwYXiXMXz25Gw2dJlOVcc0=";

  mypy-boto3-discovery =
    buildMypyBoto3Package "discovery" "1.40.19"
      "sha256-dq0rCFW8Cc9nQkRNNYaZs092nOjLqdob7rziv/WDNfo=";

  mypy-boto3-dlm =
    buildMypyBoto3Package "dlm" "1.40.54"
      "sha256-cCVm6rzKk9TX7/LamWAPgN/nGWzwlbx/e+v/rDeAPRY=";

  mypy-boto3-dms =
    buildMypyBoto3Package "dms" "1.40.43"
      "sha256-Is9yMouO7WxY/P7ViK+s8Y1q8Y7KvTvY7X/H4ndeG6s=";

  mypy-boto3-docdb =
    buildMypyBoto3Package "docdb" "1.40.53"
      "sha256-yHfHczjN4v+5IoQy9WuSEGWnhKiF70xJxsxiYHj/s+Y=";

  mypy-boto3-docdb-elastic =
    buildMypyBoto3Package "docdb-elastic" "1.40.0"
      "sha256-TKVaVd92g+2bV5NNRnLuVZQw0lZycTyeyjB6UgV+iHc=";

  mypy-boto3-drs =
    buildMypyBoto3Package "drs" "1.40.0"
      "sha256-dtw54zAzP4HddWx0kZr7SzxmWiKCiiP6g4+aDRRid2k=";

  mypy-boto3-ds =
    buildMypyBoto3Package "ds" "1.40.42"
      "sha256-gKzshS6Q6O/lTAsrkuXOvKkGz+ECRlmSeb5NxNCBim8=";

  mypy-boto3-dynamodb =
    buildMypyBoto3Package "dynamodb" "1.40.44"
      "sha256-WPo6Y4scrvVkS2D1iU4RgqKVH+swo9xt7bNOGwyd7Zk=";

  mypy-boto3-dynamodbstreams =
    buildMypyBoto3Package "dynamodbstreams" "1.40.40"
      "sha256-TgENR4bY5AHy0hqJkTq63jApASafB6agMPFPYDlzJ7A=";

  mypy-boto3-ebs =
    buildMypyBoto3Package "ebs" "1.40.15"
      "sha256-jtkx0kbI7SB74U5uWyGdVhKMlsy/T82lz3P89k8LMPA=";

  mypy-boto3-ec2 =
    buildMypyBoto3Package "ec2" "1.40.53"
      "sha256-SCjXpXIBjg31/0OknDgJfBBvVCf8gUSDiuD4IGETGeA=";

  mypy-boto3-ec2-instance-connect =
    buildMypyBoto3Package "ec2-instance-connect" "1.40.20"
      "sha256-x5DKz6GllTWBgkzFPnZehs7Fh3YgWGZlnJG/chPqds4=";

  mypy-boto3-ecr =
    buildMypyBoto3Package "ecr" "1.40.0"
      "sha256-dzPkK8ipL/2Tvr8DQ68TP9UmmP/r0yPYL/3nVc4oaH8=";

  mypy-boto3-ecr-public =
    buildMypyBoto3Package "ecr-public" "1.40.15"
      "sha256-mkaBmHn3LsOHnH4kTWkGbCsL4w/TrPBt/pBXnj+1Ai8=";

  mypy-boto3-ecs =
    buildMypyBoto3Package "ecs" "1.40.43"
      "sha256-wVaLCKZXJJG32j2dUjzxj1Q2slgulxZ8xhqKXWenTUc=";

  mypy-boto3-efs =
    buildMypyBoto3Package "efs" "1.40.0"
      "sha256-DQZUI72cnRt4YwHMQivMdL4y9B9EN2H7dIMmybcX/Uk=";

  mypy-boto3-eks =
    buildMypyBoto3Package "eks" "1.40.36"
      "sha256-xlT0PW+10gO1jpddeCR82y+4+A9e1SNK756ph8/1Iik=";

  mypy-boto3-elastic-inference =
    buildMypyBoto3Package "elastic-inference" "1.36.0"
      "sha256-duU3LIeW3FNiplVmduZsNXBoDK7vbO6ecrBt1Y7C9rU=";

  mypy-boto3-elasticache =
    buildMypyBoto3Package "elasticache" "1.40.19"
      "sha256-YaNGVCO/MGDn/9YQBquhqqg1YHmJK3grdk/wVdF4erQ=";

  mypy-boto3-elasticbeanstalk =
    buildMypyBoto3Package "elasticbeanstalk" "1.40.15"
      "sha256-TMfQt3rK4aT7DnlJCbJj7sFrDL9NqQc4kQS8sdTdDS0=";

  mypy-boto3-elastictranscoder =
    buildMypyBoto3Package "elastictranscoder" "1.40.18"
      "sha256-ObCzDvt0o59FXWw3bAh67Gh1QJNx7HjDEE0pMCcHkCs=";

  mypy-boto3-elb =
    buildMypyBoto3Package "elb" "1.40.16"
      "sha256-9LKKt1qGw/gWS+XtNzmnjk0WOFHAmTuzkj9D3tYuMtU=";

  mypy-boto3-elbv2 =
    buildMypyBoto3Package "elbv2" "1.40.53"
      "sha256-TGc78KsQ4y8QSFutN+/cj/gr2iJWi7fYh52OYFCFwho=";

  mypy-boto3-emr =
    buildMypyBoto3Package "emr" "1.40.0"
      "sha256-crNaa6bqSP7fCsFV5CnAHazDpXrFkkb46ria2LWTDvY=";

  mypy-boto3-emr-containers =
    buildMypyBoto3Package "emr-containers" "1.40.29"
      "sha256-1TDHCMuGVUm8WlKFmIT0fgSv/9Hdyy4qJLAaNcdrMQE=";

  mypy-boto3-emr-serverless =
    buildMypyBoto3Package "emr-serverless" "1.40.0"
      "sha256-9Iz9FapUQCWa9bjmH0Ar9O1mtTv+ovWlxikddb5+Wlc=";

  mypy-boto3-entityresolution =
    buildMypyBoto3Package "entityresolution" "1.40.37"
      "sha256-n5aa7oK/37pT1f+xFXu8Sp3LfO1UAcUljCqdtSZ/fPQ=";

  mypy-boto3-es =
    buildMypyBoto3Package "es" "1.40.15"
      "sha256-nIRSeL+cX4FVozkogF455I0kGhNJUOMauQPOxCtju50=";

  mypy-boto3-events =
    buildMypyBoto3Package "events" "1.40.0"
      "sha256-NifbOgZ8Q0oUnKchIt04RgMMDBXMiwJJCKDmax3j4Es=";

  mypy-boto3-evidently =
    buildMypyBoto3Package "evidently" "1.40.19"
      "sha256-v4FSQ3YR4s9hgu7SBhHWebkgSmDFDN5qf1/XKo2zlvs=";

  mypy-boto3-finspace =
    buildMypyBoto3Package "finspace" "1.40.18"
      "sha256-jB4Yb1hX9P8bhY0cprew6S1VgG4G/IVo3OlGuAojQ38=";

  mypy-boto3-finspace-data =
    buildMypyBoto3Package "finspace-data" "1.40.17"
      "sha256-fePfBO2KWcMACejuSer80O2LCEuwh/pjA6wkEpUL9os=";

  mypy-boto3-firehose =
    buildMypyBoto3Package "firehose" "1.40.0"
      "sha256-Zzp7VoPaVIHX3KccxlFILesGNJP7f1p63uXLwN3rLcs=";

  mypy-boto3-fis =
    buildMypyBoto3Package "fis" "1.40.20"
      "sha256-vQKaLV+lEh4zjYhAn1/8lT9cm2xokMrU2sdsoBmfcjc=";

  mypy-boto3-fms =
    buildMypyBoto3Package "fms" "1.40.20"
      "sha256-yBhVmfeAexcJzkxC3AdtWOC4PjCoTDozxYT6qrgEHJ8=";

  mypy-boto3-forecast =
    buildMypyBoto3Package "forecast" "1.40.17"
      "sha256-PMEWvzCP8gTKwsV9oIjqIB7jIMDZDjLqdPO/G7nnfDc=";

  mypy-boto3-forecastquery =
    buildMypyBoto3Package "forecastquery" "1.40.15"
      "sha256-QPQz6ou7edU28tUPuoFq4v3Hnz/uASm46c7TMSOy+WY=";

  mypy-boto3-frauddetector =
    buildMypyBoto3Package "frauddetector" "1.40.19"
      "sha256-BpY3WWeFvaGfDaGk/dxJijSK3giz7wrgvHk/lKOaxzk=";

  mypy-boto3-fsx =
    buildMypyBoto3Package "fsx" "1.40.42"
      "sha256-phgje7MZt9KoKUb6bQYqZ4/BqjYflEDPJ/uN7J04zuE=";

  mypy-boto3-gamelift =
    buildMypyBoto3Package "gamelift" "1.40.54"
      "sha256-p8iNFeQAwp5WdsqHNA8+mMBNvt6y1t6+erP2APopH0Y=";

  mypy-boto3-glacier =
    buildMypyBoto3Package "glacier" "1.40.18"
      "sha256-lEYmHnV9ADvj1BqZEeEBakiPLkfFNg4eUjx/ByEnrLQ=";

  mypy-boto3-globalaccelerator =
    buildMypyBoto3Package "globalaccelerator" "1.40.54"
      "sha256-NkEe4fOx9ZH6SHfa3A8UHXLyxIgjVGvy4UL+HkUiCDA=";

  mypy-boto3-glue =
    buildMypyBoto3Package "glue" "1.40.50"
      "sha256-1LgvvSs/ZFxrCT/7MhZDATFUI6az5yTAhuc41QQ1kGk=";
  mypy-boto3-grafana =
    buildMypyBoto3Package "grafana" "1.40.54"
      "sha256-GeYE+d3wv+KTcS0ve0ftTLXazGS5a5KMQmVMXMl9jtM=";

  mypy-boto3-greengrass =
    buildMypyBoto3Package "greengrass" "1.40.18"
      "sha256-2LlUVjYGni7omje8tlvAJNkKDVSbVIF4mnUNzb01lUQ=";

  mypy-boto3-greengrassv2 =
    buildMypyBoto3Package "greengrassv2" "1.40.15"
      "sha256-/O+fM3MU2HtFIt1S8+yE3RG59dsHKwJbnINaVmYUnD0=";

  mypy-boto3-groundstation =
    buildMypyBoto3Package "groundstation" "1.40.0"
      "sha256-/LlMFYC7cJWb9C5JIt0dTEPtl2sPsalSq7mYaFSf3c4=";

  mypy-boto3-guardduty =
    buildMypyBoto3Package "guardduty" "1.40.53"
      "sha256-gTfRwvZekeaQ8V7QgepE4S+i134YQiJ1UXDTU+otVZ8=";

  mypy-boto3-health =
    buildMypyBoto3Package "health" "1.40.0"
      "sha256-c/QCgM8mWIAe76C7e3+g9z3i/ukvOz9QGungofo2hY8=";

  mypy-boto3-healthlake =
    buildMypyBoto3Package "healthlake" "1.40.20"
      "sha256-CzEuUubTbrx+BsfOfRgqjykewZfsnMqRNAqWalAfS9o=";

  mypy-boto3-iam =
    buildMypyBoto3Package "iam" "1.40.0"
      "sha256-uQCsVXN1Qo8LvDeqJP3SkB4ttwGK5E4Kr5nsD4SijUQ=";

  mypy-boto3-identitystore =
    buildMypyBoto3Package "identitystore" "1.40.54"
      "sha256-A9nivPF85KQUnfo2aF6a50NTSxox2OlXXS4MuxNnZ1g=";

  mypy-boto3-imagebuilder =
    buildMypyBoto3Package "imagebuilder" "1.40.41"
      "sha256-vGem/ZZqqYL3sjrf2gTlMx/YTB+lHcG9lJcJLjGRkOk=";

  mypy-boto3-importexport =
    buildMypyBoto3Package "importexport" "1.40.0"
      "sha256-ba01dCNMlcTw/+WrulQkCtDagcPO7FF94cgkY14Pgsg=";

  mypy-boto3-inspector =
    buildMypyBoto3Package "inspector" "1.40.19"
      "sha256-9+HawjY2kx6JE+UABDKApvTYLzQqx/eBQ3ORQ5M0fq0=";

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
    buildMypyBoto3Package "iotanalytics" "1.40.16"
      "sha256-kLN+S5x9XMO8TovR57hwXnqQvC6K+JwHncgmrLFOpFY=";

  mypy-boto3-iotdeviceadvisor =
    buildMypyBoto3Package "iotdeviceadvisor" "1.40.15"
      "sha256-E6Y+2g7LsW7wbF1t/SAiFN5S9p0+4vwNykkJdl19voA=";

  mypy-boto3-iotevents =
    buildMypyBoto3Package "iotevents" "1.40.15"
      "sha256-Q1s5t45DKkIeolXDh6fhoiYVomIdFTTZyhiGkSrlNgo=";

  mypy-boto3-iotevents-data =
    buildMypyBoto3Package "iotevents-data" "1.40.15"
      "sha256-CIr9UTs6qHRvEWrlHLooTOYzFKaWA+BwG/N8Fp+XTJg=";

  mypy-boto3-iotfleethub =
    buildMypyBoto3Package "iotfleethub" "1.40.17"
      "sha256-SeJi6Z/TJAiqL6+21CMP6iZF/Skv1hnmldPrJpOHUfo=";

  mypy-boto3-iotfleetwise =
    buildMypyBoto3Package "iotfleetwise" "1.40.0"
      "sha256-PER1D68w6wBvHUH5CGEn4H1zku92vhcwWDFRpoXZlmg=";

  mypy-boto3-iotsecuretunneling =
    buildMypyBoto3Package "iotsecuretunneling" "1.40.18"
      "sha256-AS7G6I5JR2tkq1m+cx+9PFaIhe7QwWH0DF/7vuIY+zQ=";

  mypy-boto3-iotsitewise =
    buildMypyBoto3Package "iotsitewise" "1.40.26"
      "sha256-nGCezdRTJ4uq7aSd0mGSOvk+/Rn4KKeCAc++KgPxRAg=";

  mypy-boto3-iotthingsgraph =
    buildMypyBoto3Package "iotthingsgraph" "1.40.15"
      "sha256-ZBh/vd5cNWOv0kk30gFXNnDrfCmlSUr8mKypEYucUgc=";

  mypy-boto3-iottwinmaker =
    buildMypyBoto3Package "iottwinmaker" "1.40.0"
      "sha256-UuQ4NUIV3ofY8/+q1dBm3DprGx//lOqngX+zzQIwvn8=";

  mypy-boto3-iotwireless =
    buildMypyBoto3Package "iotwireless" "1.40.0"
      "sha256-Kj/g5lCH7AgHRlSU6od3O4j1OilposHoDP1hYX4S+fs=";

  mypy-boto3-ivs =
    buildMypyBoto3Package "ivs" "1.40.54"
      "sha256-t4l1s2RCkP572kbJLxsbh5EQnKZXk6zPc82PYytFzEQ=";

  mypy-boto3-ivs-realtime =
    buildMypyBoto3Package "ivs-realtime" "1.40.54"
      "sha256-gumv3tmf4bQa6HvlTAYh7yK0cE1jn3Gprt9l1iHgXqo=";

  mypy-boto3-ivschat =
    buildMypyBoto3Package "ivschat" "1.40.0"
      "sha256-mtWPF8wmFGLC0PqkKX/UiYT6/VG7FfgrbsqTqRIOgsA=";

  mypy-boto3-kafka =
    buildMypyBoto3Package "kafka" "1.40.54"
      "sha256-3hhwZY3Cxc18YpLmXfglgMV8OevwEFJymdVOIcAa/sI=";

  mypy-boto3-kafkaconnect =
    buildMypyBoto3Package "kafkaconnect" "1.40.0"
      "sha256-4wNbhuNsLwrYemkPuadR6oeaCuSajU5IwCb0En89M3U=";

  mypy-boto3-kendra =
    buildMypyBoto3Package "kendra" "1.40.17"
      "sha256-IOj6WGiMgCtbLlZ+AHvSAYZFYLxBiXWUA1VKDPBBe+Y=";

  mypy-boto3-kendra-ranking =
    buildMypyBoto3Package "kendra-ranking" "1.40.35"
      "sha256-k8g4A54sQvehWCgxaV15zE5vVvJLS6hBrLMDEjGlXxs=";

  mypy-boto3-keyspaces =
    buildMypyBoto3Package "keyspaces" "1.40.54"
      "sha256-NLkf8t9W/ZKA7S9qc/qJ1u4bzh87unvsQLUeh92sbvg=";

  mypy-boto3-kinesis =
    buildMypyBoto3Package "kinesis" "1.40.0"
      "sha256-T3T3FeI6jc4GK0D2pPL/ECPOxvQbRSHwvBVnmIOn5o4=";

  mypy-boto3-kinesis-video-archived-media =
    buildMypyBoto3Package "kinesis-video-archived-media" "1.40.17"
      "sha256-wKaV5LpNWviCW+R1kiEEUdi91BE42Q5/fdq7FpqkGaM=";

  mypy-boto3-kinesis-video-media =
    buildMypyBoto3Package "kinesis-video-media" "1.40.19"
      "sha256-PrKUrdt2F3QnznSfJjLt+cbMvSd6bhc0qPD0c8OAKn4=";

  mypy-boto3-kinesis-video-signaling =
    buildMypyBoto3Package "kinesis-video-signaling" "1.40.15"
      "sha256-3XwZsjSiQmed7Msz2HHP796iY9x2nSyd6aMglkv3Lfo=";

  mypy-boto3-kinesis-video-webrtc-storage =
    buildMypyBoto3Package "kinesis-video-webrtc-storage" "1.40.0"
      "sha256-cnUWkJfPyd7G9ClFFWNXHFwuSqmTcUHwluPBeF4qO8o=";

  mypy-boto3-kinesisanalytics =
    buildMypyBoto3Package "kinesisanalytics" "1.40.17"
      "sha256-OU9dcphpwEqoTDleItqOluVxpu73KbWUU3bwflXKO9M=";

  mypy-boto3-kinesisanalyticsv2 =
    buildMypyBoto3Package "kinesisanalyticsv2" "1.40.14"
      "sha256-rb9scmO7uC9WmimwoCkWyM11yfOSZHQgQR2w1PkRRo0=";

  mypy-boto3-kinesisvideo =
    buildMypyBoto3Package "kinesisvideo" "1.40.19"
      "sha256-ntnY800namdoyhCPe0Pg5573l2J75Wqd+yFat5KEaMc=";

  mypy-boto3-kms =
    buildMypyBoto3Package "kms" "1.40.54"
      "sha256-0+dJmIiBbQPcy6xbmn/qjvAyI84YF5AvGJFzZBQAP3g=";

  mypy-boto3-lakeformation =
    buildMypyBoto3Package "lakeformation" "1.40.19"
      "sha256-NMF0B6cBjIFJl7CKrwxj89oFJeYnDhpdkmCTJdXa3w0=";

  mypy-boto3-lambda =
    buildMypyBoto3Package "lambda" "1.40.50"
      "sha256-pwngrGlAeDqtCP9c+Yx4miFYQLqxfkaMpeIjBa0K6gU=";

  mypy-boto3-lex-models =
    buildMypyBoto3Package "lex-models" "1.40.54"
      "sha256-1154wsf4q7QHWQG3PGo+ukUJY2mk+xfh3/56YKRtXIE=";

  mypy-boto3-lex-runtime =
    buildMypyBoto3Package "lex-runtime" "1.40.17"
      "sha256-Bt0APaVZxgwASjYTMUctwbsb7u2ZFOf5a3UlComKWxs=";

  mypy-boto3-lexv2-models =
    buildMypyBoto3Package "lexv2-models" "1.40.0"
      "sha256-FgQalWvHO0Zzisw9CLKIKeNchDh5DMHjos2OIyXto40=";

  mypy-boto3-lexv2-runtime =
    buildMypyBoto3Package "lexv2-runtime" "1.40.54"
      "sha256-beE9BjjI8wZFwDy0Xzv0/BmRjunfJlJ0qASf4yfpxpE=";

  mypy-boto3-license-manager =
    buildMypyBoto3Package "license-manager" "1.40.0"
      "sha256-9Afe020suiP14DlvvGETT+3wlUfPWC3qW+47SAxwHuI=";

  mypy-boto3-license-manager-linux-subscriptions =
    buildMypyBoto3Package "license-manager-linux-subscriptions" "1.40.0"
      "sha256-pfIQS9as02Gm4mHUc3q3gMKRHz+wT/lRKHWUc2ugt1s=";

  mypy-boto3-license-manager-user-subscriptions =
    buildMypyBoto3Package "license-manager-user-subscriptions" "1.40.48"
      "sha256-hp2jCL1IkXluhEyexdawQvwLfk+9pUVjKlnE9dkVnxc=";

  mypy-boto3-lightsail =
    buildMypyBoto3Package "lightsail" "1.40.53"
      "sha256-UzFFqox5VlOBemuJ7oPybKtNx+y9yNlC9wc3r1FidEw=";

  mypy-boto3-location =
    buildMypyBoto3Package "location" "1.40.0"
      "sha256-hAUULqVRGPw0Ir0XUyhREqT8C8A99lJEGYn4nAxnW7A=";

  mypy-boto3-logs =
    buildMypyBoto3Package "logs" "1.40.32"
      "sha256-udjRe+Pb6Yvbh6OHYs32VCTddkrAo/y1Se32A+FM1/M=";

  mypy-boto3-lookoutequipment =
    buildMypyBoto3Package "lookoutequipment" "1.40.54"
      "sha256-TW5IgaSvPWbBu39VsO+6HMpgzu1TAKZ62RZGUQ3HoFo=";

  mypy-boto3-lookoutmetrics =
    buildMypyBoto3Package "lookoutmetrics" "1.40.15"
      "sha256-ZcL1sZGlckqZFhCqTZwMeghP8K9Hee1Zi3N6wZb9hts=";

  mypy-boto3-lookoutvision =
    buildMypyBoto3Package "lookoutvision" "1.40.18"
      "sha256-DKGXLR3lVek8IHAolI372LKc5YFy1o40DUVxp+xc1ww=";

  mypy-boto3-m2 =
    buildMypyBoto3Package "m2" "1.40.54"
      "sha256-qpYLmQ4CfAG30fnY86vT74B33pmD1cDGLHrKiuDOpN8=";

  mypy-boto3-machinelearning =
    buildMypyBoto3Package "machinelearning" "1.40.54"
      "sha256-3LzaMWu1lPzmKx8+Knc9OdwgElOMumhkt9iEn1gShCY=";

  mypy-boto3-macie2 =
    buildMypyBoto3Package "macie2" "1.40.16"
      "sha256-JKGY573KRt5XWgLVcNvlNgTdFYHC7Qj/YNcdODmUF00=";

  mypy-boto3-managedblockchain =
    buildMypyBoto3Package "managedblockchain" "1.40.15"
      "sha256-YBNBXwG0T7a805OPXYmCvqh8wHubtMG3QW38/eCCuB4=";

  mypy-boto3-managedblockchain-query =
    buildMypyBoto3Package "managedblockchain-query" "1.40.0"
      "sha256-lw7LeVq/o8RFK9P62vQ7iR+jZfH/OOZY2AirYqDltSw=";

  mypy-boto3-marketplace-catalog =
    buildMypyBoto3Package "marketplace-catalog" "1.40.0"
      "sha256-C33HMjDet8ZhC2CUlr0xkYlLQpIOMKjhbqKw7CPz+Tg=";

  mypy-boto3-marketplace-entitlement =
    buildMypyBoto3Package "marketplace-entitlement" "1.40.54"
      "sha256-pagUH5QLYtbx88TE9470AJOHxG29ALGxZioROq3rqTE=";

  mypy-boto3-marketplacecommerceanalytics =
    buildMypyBoto3Package "marketplacecommerceanalytics" "1.40.16"
      "sha256-7gZOd0TBAWyyY7g85UXAjp4miV08qfB20B6YQww360w=";

  mypy-boto3-mediaconnect =
    buildMypyBoto3Package "mediaconnect" "1.40.46"
      "sha256-IjfRXktKU9nJlBJhET307e+nvbwqCucIj0E2dpwuZO4=";

  mypy-boto3-mediaconvert =
    buildMypyBoto3Package "mediaconvert" "1.40.17"
      "sha256-L2/TEQbnd60RuCaqpNI/xyQ76AqbIUe5KWwZtSf+2I8=";

  mypy-boto3-medialive =
    buildMypyBoto3Package "medialive" "1.40.45"
      "sha256-rF8r53gdOYPeFJ5VqUWLiQ9rNaUAIb1tS5E9TSHgrms=";

  mypy-boto3-mediapackage =
    buildMypyBoto3Package "mediapackage" "1.40.15"
      "sha256-HMPme3zTPKCGRHUhRXgw83o0UV+Frz25+0eOEB9cDdA=";

  mypy-boto3-mediapackage-vod =
    buildMypyBoto3Package "mediapackage-vod" "1.40.17"
      "sha256-T3Ba5a0ogaaNqOs93jww/OT2UgHZzy9k6YGpkN9DlYY=";

  mypy-boto3-mediapackagev2 =
    buildMypyBoto3Package "mediapackagev2" "1.40.54"
      "sha256-JPlD+hxnut6l3LAp5jNfP0LCdPj/wVj7xs/wSP+sy0U=";

  mypy-boto3-mediastore =
    buildMypyBoto3Package "mediastore" "1.40.17"
      "sha256-YCFhcxgtQvf9MhwzCHqjGPX666dv35lkTLhxp4wGog0=";

  mypy-boto3-mediastore-data =
    buildMypyBoto3Package "mediastore-data" "1.40.20"
      "sha256-hkzc8MTCssJPCjME7CMCVewYgNf9Gz/c68hAC3fuKnE=";

  mypy-boto3-mediatailor =
    buildMypyBoto3Package "mediatailor" "1.40.42"
      "sha256-wTzLtvXBVTEs1ywAw8sL92Xzyo9TOscaIptPE1oHrUg=";

  mypy-boto3-medical-imaging =
    buildMypyBoto3Package "medical-imaging" "1.40.54"
      "sha256-pDcksj0s3L+AKKXDe9fmcYxDdQDa5uVdbtJLGSvW0X0=";

  mypy-boto3-memorydb =
    buildMypyBoto3Package "memorydb" "1.40.54"
      "sha256-f/tGLKRnpzMDLAzQH1W7sUjGljb04Ws5Tidh8lL0pWE=";

  mypy-boto3-meteringmarketplace =
    buildMypyBoto3Package "meteringmarketplace" "1.40.0"
      "sha256-wbPakhKKDtNY6y84jzqJQlP7IiG5QAKQTRsYP/tndV8=";

  mypy-boto3-mgh =
    buildMypyBoto3Package "mgh" "1.40.18"
      "sha256-6PlBNNCfxt4MLqmDPM6icIyutPGyXd54AWKHxCTQ024=";

  mypy-boto3-mgn =
    buildMypyBoto3Package "mgn" "1.40.0"
      "sha256-XyB7/8zj4pU/+cxqhEf2WMoBoo/J12lOrlL0WD2Nhic=";

  mypy-boto3-migration-hub-refactor-spaces =
    buildMypyBoto3Package "migration-hub-refactor-spaces" "1.40.18"
      "sha256-SVy3+tok3qsJv76TiaOIPVSnJiGxfuPgAYT+bi3Kxss=";

  mypy-boto3-migrationhub-config =
    buildMypyBoto3Package "migrationhub-config" "1.40.54"
      "sha256-djL6fA1ekMWn1Alc3mchrdydGCkVXsDtKNc/fG4xGL0=";

  mypy-boto3-migrationhuborchestrator =
    buildMypyBoto3Package "migrationhuborchestrator" "1.40.0"
      "sha256-EtOj4OjZBn5M5Q9pU2MaSNwXAVXbtFEZICRn/r+e9OQ=";

  mypy-boto3-migrationhubstrategy =
    buildMypyBoto3Package "migrationhubstrategy" "1.40.0"
      "sha256-G+Kn0K9lI24r/A+KBOE2euh+raKIystZ7uB2k9AD/Zg=";

  mypy-boto3-mq =
    buildMypyBoto3Package "mq" "1.40.23"
      "sha256-1+/fGIJPzPvAThyGy6ZiZAyIfFGtBGiBZ1ORwfTZ2Ww=";

  mypy-boto3-mturk =
    buildMypyBoto3Package "mturk" "1.40.20"
      "sha256-+VSk5ytyDwIkg8Ur15vjBmURPwXvZkRT5UEKPTWNgO8=";

  mypy-boto3-mwaa =
    buildMypyBoto3Package "mwaa" "1.40.0"
      "sha256-w/km0Eq/rEX182tDtxVsFCm3bK2pUr1Fh6ZnsX6thAI=";

  mypy-boto3-neptune =
    buildMypyBoto3Package "neptune" "1.40.38"
      "sha256-3vbUWdYw7jqTM5TPM3btPROlXPW1xR+3cI29ImVrt1w=";

  mypy-boto3-neptunedata =
    buildMypyBoto3Package "neptunedata" "1.40.0"
      "sha256-5aD/9ACgD/76bPpbZlqHXn0biTxr9wyiLpTyIdxMKYs=";

  mypy-boto3-network-firewall =
    buildMypyBoto3Package "network-firewall" "1.40.39"
      "sha256-ZJT+qoOmgMRj3f0mIxDJ7wuPhlQykdbXOyeo6YYQmOg=";

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
    buildMypyBoto3Package "omics" "1.40.20"
      "sha256-I53YcVk2rMNP+4WrD+6kvo85OhKrvJoE2YR3UBeIgEY=";

  mypy-boto3-opensearch =
    buildMypyBoto3Package "opensearch" "1.40.0"
      "sha256-DduRVsWhYZPX+mQAj1j1kA00rilUHKA4SnmehgS4hYU=";

  mypy-boto3-opensearchserverless =
    buildMypyBoto3Package "opensearchserverless" "1.40.24"
      "sha256-dWkO3WKxcMFLF4UvFLAgAv1vfJZYqwua6s+CYGhTF0g=";

  mypy-boto3-opsworks =
    buildMypyBoto3Package "opsworks" "1.40.0"
      "sha256-ZuSVlDalSjVyMGVem02HklbAmDZXJeWnd2GBrMFJKHU=";

  mypy-boto3-opsworkscm =
    buildMypyBoto3Package "opsworkscm" "1.40.0"
      "sha256-JEuEjo0htTuDCZx2nNJK2Zq59oSUqkMf4BrNamerfVk=";

  mypy-boto3-organizations =
    buildMypyBoto3Package "organizations" "1.40.27"
      "sha256-LdBoeGucR8RzewzflvN1dtCtr8+asp3ggmtV6HuUQm8=";

  mypy-boto3-osis =
    buildMypyBoto3Package "osis" "1.40.54"
      "sha256-iuSKo8JCPNNc6FiyKbIpkbVd5rgqRGKOKASwqkCstdw=";

  mypy-boto3-outposts =
    buildMypyBoto3Package "outposts" "1.40.48"
      "sha256-9N7I4XQQP/vUvGvMYT8SnYRJFWEKm7YMjtTgkTMnY8I=";

  mypy-boto3-panorama =
    buildMypyBoto3Package "panorama" "1.40.15"
      "sha256-PgXa3veO1qGxxUBwZe2bxauFNT3nc0j8vEVk0Q4NtVU=";

  mypy-boto3-payment-cryptography =
    buildMypyBoto3Package "payment-cryptography" "1.40.30"
      "sha256-JSLXvrURvUhb83Oeb5b+hlDpOoiFMayDtDXGJsx8Hsw=";

  mypy-boto3-payment-cryptography-data =
    buildMypyBoto3Package "payment-cryptography-data" "1.40.45"
      "sha256-/mlrjDkzD9szPLpV+69UBhYXpzt8vwPXIoAMGt+LZxc=";

  mypy-boto3-pca-connector-ad =
    buildMypyBoto3Package "pca-connector-ad" "1.40.0"
      "sha256-6kAZW0V/7XXEGCQl24brFhR3utzZ0Ftg8dTUgRN40iU=";

  mypy-boto3-personalize =
    buildMypyBoto3Package "personalize" "1.40.54"
      "sha256-pn+Zpzpa5SBhnzzo1yVcQzFi3u3Wbf93AvOL4Xu+yqQ=";

  mypy-boto3-personalize-events =
    buildMypyBoto3Package "personalize-events" "1.40.18"
      "sha256-ot000kDzq6Dle+9d9EWXHM7kLIzA4Se7X1w24dEhLVg=";

  mypy-boto3-personalize-runtime =
    buildMypyBoto3Package "personalize-runtime" "1.40.54"
      "sha256-vuOhtYDVqnB4Xn5dzE3N93b7ZWalyvPwTx01CHFzSNo=";

  mypy-boto3-pi =
    buildMypyBoto3Package "pi" "1.40.19"
      "sha256-kpZHz/E6ES5zUyqhTYN/9OMBEQtrf+uOz85spmIeQEc=";

  mypy-boto3-pinpoint =
    buildMypyBoto3Package "pinpoint" "1.40.18"
      "sha256-zhekW0Dk58LRUfyVd6slsy3tKu31j/cGEYfkvpLrmnA=";

  mypy-boto3-pinpoint-email =
    buildMypyBoto3Package "pinpoint-email" "1.40.15"
      "sha256-MZ3FLJdyo1RoUFj6baYu4dR9T8/0nCilk5RRZ+0wvQQ=";

  mypy-boto3-pinpoint-sms-voice =
    buildMypyBoto3Package "pinpoint-sms-voice" "1.40.54"
      "sha256-3c8he41vrrQwW64aGB5ExykWVPqGfj73P0gZBYoqsW0=";

  mypy-boto3-pinpoint-sms-voice-v2 =
    buildMypyBoto3Package "pinpoint-sms-voice-v2" "1.40.14"
      "sha256-Jogfc4bdSgo6ufRjkX+jC6tCcjF2QEF5Wc5a3tZxjPM=";

  mypy-boto3-pipes =
    buildMypyBoto3Package "pipes" "1.40.0"
      "sha256-AY8HH2OrOvscERskVLYOx8c8MQntEEseeVwpN6cJuaY=";

  mypy-boto3-polly =
    buildMypyBoto3Package "polly" "1.40.54"
      "sha256-3qic3Zk9WZ1JF570ASGt6X6EBeWO4hGhs4kYQZ3RfQg=";

  mypy-boto3-pricing =
    buildMypyBoto3Package "pricing" "1.40.54"
      "sha256-5XQk+0F6fX80cEOQlHTZOpcbl2qpaAJOgqawem8kMpI=";

  mypy-boto3-privatenetworks =
    buildMypyBoto3Package "privatenetworks" "1.38.0"
      "sha256-T04icQC+XwQZhaAEBWRiqfCUaayXP1szpbLdAG/7t3k=";

  mypy-boto3-proton =
    buildMypyBoto3Package "proton" "1.40.47"
      "sha256-BEHP+U37pdHVP7UABWkS3zUYNg+xE6Z/A8mmmd0/LmE=";

  mypy-boto3-qldb =
    buildMypyBoto3Package "qldb" "1.40.16"
      "sha256-IaEZm5lbmuWg/Y6BHJ6ABKBPlQsvCCRIBkQk1xbc9PI=";

  mypy-boto3-qldb-session =
    buildMypyBoto3Package "qldb-session" "1.40.19"
      "sha256-g5Mh+Uz/YrF4v7GV3kPUarzTr0miTUioaMaxwYUX4p0=";

  mypy-boto3-quicksight =
    buildMypyBoto3Package "quicksight" "1.40.49"
      "sha256-skz5HFlXRIhqefMOSN8lvhmAuu+COBC/hl8YGJawXSI=";

  mypy-boto3-ram =
    buildMypyBoto3Package "ram" "1.40.18"
      "sha256-eguBtTttYrCcdQ1HYyy7zNVXqVkBbG59aHwzgiV1PwY=";

  mypy-boto3-rbin =
    buildMypyBoto3Package "rbin" "1.40.18"
      "sha256-zye0xv5P6GemZiH+T/cIyzx9qaeOKitEWpW6LOkc8KM=";

  mypy-boto3-rds =
    buildMypyBoto3Package "rds" "1.40.50"
      "sha256-fVUGv36rK1kmb5MmEEnCrCXEYPfgn1g6u4aYBpnDvtU=";

  mypy-boto3-rds-data =
    buildMypyBoto3Package "rds-data" "1.40.0"
      "sha256-EjuSI3v4i4PRTmcQtqRTRdgfBXBBzF9ChJV9x6VCdtY=";

  mypy-boto3-redshift =
    buildMypyBoto3Package "redshift" "1.40.40"
      "sha256-S2Kq4+up5zWfLS2rM14qwmzLd1h13hz8YURBq9O715w=";

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
    buildMypyBoto3Package "resource-explorer-2" "1.40.46"
      "sha256-x1BJr6TZpO5OlfAG5l9PuAmfTAMtjnRv3SWO6bh2zPc=";

  mypy-boto3-resource-groups =
    buildMypyBoto3Package "resource-groups" "1.40.15"
      "sha256-q6SqqJEsDrQfjYpiFp1S2+CnAjKUW+wBsLVSjYng9ZE=";

  mypy-boto3-resourcegroupstaggingapi =
    buildMypyBoto3Package "resourcegroupstaggingapi" "1.40.17"
      "sha256-y80XkJoge5ED3oj4562wlG8GaXcCzTI8It58RW+skRQ=";

  mypy-boto3-robomaker =
    buildMypyBoto3Package "robomaker" "1.40.19"
      "sha256-qPJ/kxKiVat3aj6aVLDgIYpoGlpsrF7kjfxJ9UWbV0o=";

  mypy-boto3-rolesanywhere =
    buildMypyBoto3Package "rolesanywhere" "1.40.0"
      "sha256-9AfMYmfGgFYxbGF1UYLBEtCkmYtlPNtD0q2MHmbJUWw=";

  mypy-boto3-route53 =
    buildMypyBoto3Package "route53" "1.40.23"
      "sha256-0cvqZsSwlq6o5XE+U9Vh3/+7I4ZhVAtlZ7Qlm5KuI1I=";

  mypy-boto3-route53-recovery-cluster =
    buildMypyBoto3Package "route53-recovery-cluster" "1.40.18"
      "sha256-2eARoNdjICq+9/NDLcgCikBIQV9WNDb8UUKGtfJA6Yw=";

  mypy-boto3-route53-recovery-control-config =
    buildMypyBoto3Package "route53-recovery-control-config" "1.40.14"
      "sha256-xHo8vLsSgGMCM3uVYv1ihLAOpkSc3XjuPgKWLFTqDkk=";

  mypy-boto3-route53-recovery-readiness =
    buildMypyBoto3Package "route53-recovery-readiness" "1.40.16"
      "sha256-oo6Vpu6SfuJKw1aqX8x6oIlLUJbHa2lNfPx5kfQMo8M=";

  mypy-boto3-route53domains =
    buildMypyBoto3Package "route53domains" "1.40.23"
      "sha256-Gj2GSKiSAicbxMjN8Gks9joOi4WB37v1xlAnjLRobOY=";

  mypy-boto3-route53resolver =
    buildMypyBoto3Package "route53resolver" "1.40.0"
      "sha256-wY1ypBS0J/0JvGJ7rc8HL52onwypC0FgkS4Zz6FKqpg=";

  mypy-boto3-rum =
    buildMypyBoto3Package "rum" "1.40.0"
      "sha256-+fgiX8rSj53vuJuuTOX26sipW3xiFDt7ik7r65alHcw=";

  mypy-boto3-s3 =
    buildMypyBoto3Package "s3" "1.40.26"
      "sha256-jSv9EFKJTQ6EyfuTWNg4ug7tAmUHbH3X9FYix3AnXJk=";

  mypy-boto3-s3control =
    buildMypyBoto3Package "s3control" "1.40.31"
      "sha256-4D9yv4nmCrc75l/QEqeP5FFNU4JPq5tAPtZi9dikcUY=";

  mypy-boto3-s3outposts =
    buildMypyBoto3Package "s3outposts" "1.40.15"
      "sha256-HPAyUwvfUNZl3Ts3H0evVO7UifAiiwrDPyYJ4titkqA=";

  mypy-boto3-sagemaker =
    buildMypyBoto3Package "sagemaker" "1.40.27"
      "sha256-OlMvXXiV/PGIqL4IRQuyRpm4RboyH+SDnQKJ2HWuqsw=";

  mypy-boto3-sagemaker-a2i-runtime =
    buildMypyBoto3Package "sagemaker-a2i-runtime" "1.40.16"
      "sha256-Mab/cO02qbhVylLWHL4aGfgMArujecXpsOgfMG7OLTk=";

  mypy-boto3-sagemaker-edge =
    buildMypyBoto3Package "sagemaker-edge" "1.40.17"
      "sha256-ZhD8T6Mp5M3Kofd462vX3HsEbazpYFOf1HJ3L9xUhGU=";

  mypy-boto3-sagemaker-featurestore-runtime =
    buildMypyBoto3Package "sagemaker-featurestore-runtime" "1.40.17"
      "sha256-p3zQ7rWP78gg2bBYdpGgVi2f771qZk+jwwxBcoQJwjk=";

  mypy-boto3-sagemaker-geospatial =
    buildMypyBoto3Package "sagemaker-geospatial" "1.40.18"
      "sha256-yzqISXyDj1FhqTvct8hc+1L1Iutnq29hSGnPAarBE+M=";

  mypy-boto3-sagemaker-metrics =
    buildMypyBoto3Package "sagemaker-metrics" "1.40.0"
      "sha256-ad7DooARgF8aOpOkvMnUig/zHHARPZe8Y6fkervBGUU=";

  mypy-boto3-sagemaker-runtime =
    buildMypyBoto3Package "sagemaker-runtime" "1.40.17"
      "sha256-NuIRRV2eq/OSMyeqKuZXGFfjzGQpX41Gx5Tv9l/2jOo=";

  mypy-boto3-savingsplans =
    buildMypyBoto3Package "savingsplans" "1.40.20"
      "sha256-N/xsDqZvv3aARvATVE5QV8yGoj7ubCrgp2TTApcfz1g=";

  mypy-boto3-scheduler =
    buildMypyBoto3Package "scheduler" "1.40.20"
      "sha256-kxBY1JSWS6R+YmXqAZGzqwOLQxBCyTYD3SSXavkmSsc=";

  mypy-boto3-schemas =
    buildMypyBoto3Package "schemas" "1.40.19"
      "sha256-cNAGZVXZKDxfU1x92cBHYa2MlVFCaFTVENt3pbsYpcY=";

  mypy-boto3-sdb =
    buildMypyBoto3Package "sdb" "1.40.0"
      "sha256-0Ih/hjzLE+pf9dXfTHLli5PYAyRGOTq5ghxNcpMN0RA=";

  mypy-boto3-secretsmanager =
    buildMypyBoto3Package "secretsmanager" "1.40.0"
      "sha256-9lCTZdXU/jJgcDutzvWhxFRV7UVOXwPzVzpQI8wXZkQ=";

  mypy-boto3-securityhub =
    buildMypyBoto3Package "securityhub" "1.40.26"
      "sha256-0DkWoaAhZ0w3CXYtQgvABDZ+PeCIjB9asQkDGSl1/oU=";

  mypy-boto3-securitylake =
    buildMypyBoto3Package "securitylake" "1.40.0"
      "sha256-DrmDjFx8N9pqL2tikWd1PD0qvBX2oI2Y9+WiDvAlOgE=";

  mypy-boto3-serverlessrepo =
    buildMypyBoto3Package "serverlessrepo" "1.40.17"
      "sha256-1YK+zUZhTf37giAyXYuZDJ8Gmg4LUZO1FwaAGViIXos=";

  mypy-boto3-service-quotas =
    buildMypyBoto3Package "service-quotas" "1.40.48"
      "sha256-9lvZvist3G5plkmsvZ4iHM2iBim8V3BmCYTbk6xDrmc=";

  mypy-boto3-servicecatalog =
    buildMypyBoto3Package "servicecatalog" "1.40.0"
      "sha256-NQpBAN1iSAgS0TcKWe8GURwxKVdjmslcfkpF8rEL3G4=";

  mypy-boto3-servicecatalog-appregistry =
    buildMypyBoto3Package "servicecatalog-appregistry" "1.40.18"
      "sha256-0UIIVr2CmQYi6QefrbpCvPvBUaw/fIyzZY6RuWWIwn4=";

  mypy-boto3-servicediscovery =
    buildMypyBoto3Package "servicediscovery" "1.40.10"
      "sha256-/Gyq9dgCjeIrNTxUqE/mvfPr+4c+Ann5+ep3/NJhrW8=";

  mypy-boto3-ses =
    buildMypyBoto3Package "ses" "1.40.20"
      "sha256-cmGVTHQ2BGpeKYymXfxMrX+AfuHky6DTNwxL0pK4NEU=";

  mypy-boto3-sesv2 =
    buildMypyBoto3Package "sesv2" "1.40.0"
      "sha256-aGK44+fTKwT+5o4bcqz1GvOm/9gpP3oX82Eta/uXc8w=";

  mypy-boto3-shield =
    buildMypyBoto3Package "shield" "1.40.17"
      "sha256-nQ2tvjrYiAvx/NH7u0F+Ys15hYfQz4sVERpw9IH2RQQ=";

  mypy-boto3-signer =
    buildMypyBoto3Package "signer" "1.40.18"
      "sha256-1SQFGuDDU8MkciZtGjkLhY0zFyIPkwvgYXJLoYEK1oI=";

  mypy-boto3-simspaceweaver =
    buildMypyBoto3Package "simspaceweaver" "1.40.16"
      "sha256-RfRroS8x3KiY5OvyRpOT8WCi37cI5YUbZj2BEOskgKk=";

  mypy-boto3-sms =
    buildMypyBoto3Package "sms" "1.40.0"
      "sha256-ZVrH3luEpHwORa+1LNdmgju3+JUy9/F6ghNzHZUicBc=";

  mypy-boto3-sms-voice =
    buildMypyBoto3Package "sms-voice" "1.38.0"
      "sha256-qWnTJxM1h3pmY2PnI8PjT7u4+xODrSQM41IK8QsJCfM=";

  mypy-boto3-snow-device-management =
    buildMypyBoto3Package "snow-device-management" "1.40.19"
      "sha256-zEYw2hrNiXj3tUFOzfLrtewLMCMFuIyXZzdzdcY7nfU=";

  mypy-boto3-snowball =
    buildMypyBoto3Package "snowball" "1.40.17"
      "sha256-MVXzb+7NvziTkEQuuo3GQdoHrrnL9859f0i07qQGnYc=";

  mypy-boto3-sns =
    buildMypyBoto3Package "sns" "1.40.1"
      "sha256-4G2J2xDIM2QJY2XGMKFE1Zyj4P22Y7vWtzvRgW0eU9s=";

  mypy-boto3-sqs =
    buildMypyBoto3Package "sqs" "1.40.35"
      "sha256-wR+V7nK924T3/s8wADcuAVR/NnNwZLeF8c80GRuH4D8=";

  mypy-boto3-ssm =
    buildMypyBoto3Package "ssm" "1.40.37"
      "sha256-2cdpa5i6N2lbul6s/gDxMFaL7zQ0QmJC3y1fpiSGtvM=";

  mypy-boto3-ssm-contacts =
    buildMypyBoto3Package "ssm-contacts" "1.40.15"
      "sha256-4My0GYzzmWFuuIgKWPxxUaCipvSYj7nsb44b7a1krbU=";

  mypy-boto3-ssm-incidents =
    buildMypyBoto3Package "ssm-incidents" "1.40.0"
      "sha256-EX4a0R3N6pWZpybsRofvsZ7Z5eQCu7eczEOHyr2S+h4=";

  mypy-boto3-ssm-sap =
    buildMypyBoto3Package "ssm-sap" "1.40.20"
      "sha256-IHBV71mK16u4EEiQddrEOEWIB4mIAjo6wyZronw8+2w=";

  mypy-boto3-sso =
    buildMypyBoto3Package "sso" "1.40.20"
      "sha256-XlnYeHhZ5IttMBKIa2rsk22QDRp2M72x1nAeJ3CiKa0=";

  mypy-boto3-sso-admin =
    buildMypyBoto3Package "sso-admin" "1.40.37"
      "sha256-TiCqp80H4oP2DyyMoKUMqndaePtj5AhzhWck/Vm82AA=";

  mypy-boto3-sso-oidc =
    buildMypyBoto3Package "sso-oidc" "1.40.37"
      "sha256-HWLKg9KykJJiv/eibjEymSRq4pThP30GKL0KwYJTRyc=";

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
    buildMypyBoto3Package "support" "1.40.17"
      "sha256-Ngqg/OaZCigXIPORzWl8CMv64KPmu8axXSgnBzBWnII=";

  mypy-boto3-support-app =
    buildMypyBoto3Package "support-app" "1.40.17"
      "sha256-PKD1uLbQHrySwD8nMt/OHqkGbu1qWyEYM2KzMMM+VR4=";

  mypy-boto3-swf =
    buildMypyBoto3Package "swf" "1.40.0"
      "sha256-qkE3rF32WkR56WB5pu3dKJLCLY5e1rvMDPYAruyj9O8=";

  mypy-boto3-synthetics =
    buildMypyBoto3Package "synthetics" "1.40.44"
      "sha256-777DKmK4DKxIWhXp+Mu7TQ8wNdfnzz4+0fJyPVGx0R0=";

  mypy-boto3-textract =
    buildMypyBoto3Package "textract" "1.40.0"
      "sha256-hMLxKQ6aMwdquw2oOgeB33OigX25MOQFJhGEBfEyf7U=";

  mypy-boto3-timestream-query =
    buildMypyBoto3Package "timestream-query" "1.40.20"
      "sha256-EHQ0m8Pr8I+CxxOolkFP6LtY4V0qGosNQTPukYg8PQ8=";

  mypy-boto3-timestream-write =
    buildMypyBoto3Package "timestream-write" "1.40.19"
      "sha256-yNvBlR2lXUMJkAUGSncExJqF85Iu9iqQWdDBGAVWgnE=";

  mypy-boto3-tnb =
    buildMypyBoto3Package "tnb" "1.40.0"
      "sha256-SfZ4sYKJic9iQfWxUQEdV233Y5NbITHWjC3Vt+hFpHA=";

  mypy-boto3-transcribe =
    buildMypyBoto3Package "transcribe" "1.40.52"
      "sha256-A93BHo29EHovA2v+hACbOhN+ckTL8JAGgftBBFzXBfM=";

  mypy-boto3-transfer =
    buildMypyBoto3Package "transfer" "1.40.52"
      "sha256-Z00yi43t9SMR1hsAG5EkvjaRKLqUU4uYwdn3KVVo+6w=";

  mypy-boto3-translate =
    buildMypyBoto3Package "translate" "1.40.17"
      "sha256-sc7qt+4ztG8uxTo05AfI47zEbQsA2DjI6vUg4vPHsb8=";

  mypy-boto3-verifiedpermissions =
    buildMypyBoto3Package "verifiedpermissions" "1.40.24"
      "sha256-AhS/FxuTPVNoi6cys6LS9wKqUKlkUZ9G3boVxJPTcNU=";

  mypy-boto3-voice-id =
    buildMypyBoto3Package "voice-id" "1.40.19"
      "sha256-voJSA17LDkjLBNDd7/TPS5tC63BfyEffvp7JUb46trk=";

  mypy-boto3-vpc-lattice =
    buildMypyBoto3Package "vpc-lattice" "1.40.41"
      "sha256-ULIgKqAo6aDuFZpl/NFS77RrR8yCss7HbRV7E25OcqE=";

  mypy-boto3-waf =
    buildMypyBoto3Package "waf" "1.40.20"
      "sha256-ypvb9EgrioTSxnTcoiEO7XV5xACxGhY9HUPbOeWVFBI=";

  mypy-boto3-waf-regional =
    buildMypyBoto3Package "waf-regional" "1.40.18"
      "sha256-r1Z15ZcuHUFEr7yUhnksIfPtxMlCrCiQw4TfRFfSW/U=";

  mypy-boto3-wafv2 =
    buildMypyBoto3Package "wafv2" "1.40.49"
      "sha256-OM6g8hX/ZPIg9cEMmCqEJfCXU/tsNUN2deqEm6HoFd4=";

  mypy-boto3-wellarchitected =
    buildMypyBoto3Package "wellarchitected" "1.40.17"
      "sha256-YCjVBZlqyrA72U/Y18Wt4j2FRLAi0YnkLYx/i9BAg34=";

  mypy-boto3-wisdom =
    buildMypyBoto3Package "wisdom" "1.40.0"
      "sha256-B+hgPZPqVl2YpsBxmkVph+L9lMv7PzJAevqMEXHAXSQ=";

  mypy-boto3-workdocs =
    buildMypyBoto3Package "workdocs" "1.40.19"
      "sha256-4EAAV8OhTKmJV0EbOJvwLUj1sxxuPzZetqt3rJo+ZTA=";

  mypy-boto3-worklink =
    buildMypyBoto3Package "worklink" "1.35.0"
      "sha256-AgK4Xg1dloJmA+h4+mcBQQVTvYKjLCk5tPDbl/ItCVQ=";

  mypy-boto3-workmail =
    buildMypyBoto3Package "workmail" "1.40.22"
      "sha256-Qnuq7/wu/rlW3mr4oCJ5isJJd9SHxzZA/cSiayVpTI0=";

  mypy-boto3-workmailmessageflow =
    buildMypyBoto3Package "workmailmessageflow" "1.40.20"
      "sha256-wOW0p/aZvOe3zQc9eIAirP4NmiVUUSxIeUwEIWbK4Eo=";

  mypy-boto3-workspaces =
    buildMypyBoto3Package "workspaces" "1.40.10"
      "sha256-6PTGF3akduOS0VRS43ykcKzK25iyQb+bqvpCe+BM9Qw=";

  mypy-boto3-workspaces-web =
    buildMypyBoto3Package "workspaces-web" "1.40.0"
      "sha256-1Nm+3yAqMg/qtpdxae2etPehfszBq454U/U/1ClPeGg=";

  mypy-boto3-xray =
    buildMypyBoto3Package "xray" "1.40.21"
      "sha256-vYgKyQDj823W9FAZST7H3hxCAdqeUM2TRSaDTLMObqs=";
}
