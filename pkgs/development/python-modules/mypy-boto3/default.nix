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
    buildMypyBoto3Package "accessanalyzer" "1.38.0"
      "sha256-y9/xQ8qsa7lI01hQTKuDBPavkQKuUX7pE4BRzwZ/bIQ=";

  mypy-boto3-account =
    buildMypyBoto3Package "account" "1.38.0"
      "sha256-AhlWp1yfbKoNGuv687k+0L8glPwFG9Nbz8Miup2pVpY=";

  mypy-boto3-acm =
    buildMypyBoto3Package "acm" "1.38.4"
      "sha256-LD7/EfcMa6UBmz8Hu4Ykp80FcOdwliCd/0Z09THI2KU=";

  mypy-boto3-acm-pca =
    buildMypyBoto3Package "acm-pca" "1.38.0"
      "sha256-zp0Z4N8MRsKjQn7UaGC+MPkBT1mTP0wbJ0a5+p6A3/s=";

  mypy-boto3-amp =
    buildMypyBoto3Package "amp" "1.38.22"
      "sha256-NoNqTKRj7/wlqoBwsEW/wgj1cBAHYRXgLVfZvkP5EV0=";

  mypy-boto3-amplify =
    buildMypyBoto3Package "amplify" "1.38.0"
      "sha256-Yv+wP2Evnr71q1ySqNuz5jxwiJAi55frDVr/Js8rOd4=";

  mypy-boto3-amplifybackend =
    buildMypyBoto3Package "amplifybackend" "1.38.0"
      "sha256-Z4i0Nl1fJ2pSgRXbNc/OXHgqdDB4Lyyh28830E5m8ak=";

  mypy-boto3-amplifyuibuilder =
    buildMypyBoto3Package "amplifyuibuilder" "1.38.0"
      "sha256-w+elhGa7/tXU8nzaE8FNLbt2f3iBCulaW1kdU2pK0wY=";

  mypy-boto3-apigateway =
    buildMypyBoto3Package "apigateway" "1.38.0"
      "sha256-KAjxv+ojo7xTGvzeHCdoQAHDXcuEkU5SQPKbmpljl5w=";

  mypy-boto3-apigatewaymanagementapi =
    buildMypyBoto3Package "apigatewaymanagementapi" "1.38.0"
      "sha256-Bn9zu0z1JgU6vUp5rJzcD4H6OenB+3QIYnA/EnjxEzI=";

  mypy-boto3-apigatewayv2 =
    buildMypyBoto3Package "apigatewayv2" "1.38.0"
      "sha256-ol6Gj+NsSOK3hInNvwLTDfWIpfD6tuSVyH52c6UhSNI=";

  mypy-boto3-appconfig =
    buildMypyBoto3Package "appconfig" "1.38.7"
      "sha256-V3UPvnKMl945aK+3gH9UrOs/DGx8Aiy/nuHtwu9N4z4=";

  mypy-boto3-appconfigdata =
    buildMypyBoto3Package "appconfigdata" "1.38.0"
      "sha256-qWBC3HzpaVMvPb61bewegZOR/J+fQTAOxqI1odKjtZk=";

  mypy-boto3-appfabric =
    buildMypyBoto3Package "appfabric" "1.38.0"
      "sha256-ajw7zE1VVIW9DhaVuAwHiOili0JRwJm2Ea2fj8yXMYY=";

  mypy-boto3-appflow =
    buildMypyBoto3Package "appflow" "1.38.0"
      "sha256-tlXyfbwuw6OIWaioqEPT3QUl84NgkMLXFh8RHUBokyE=";

  mypy-boto3-appintegrations =
    buildMypyBoto3Package "appintegrations" "1.38.0"
      "sha256-5AFYyCJk6eHKDaqBSl8Po/jj6Fkwr5JYgMtxGrdWGRQ=";

  mypy-boto3-application-autoscaling =
    buildMypyBoto3Package "application-autoscaling" "1.38.21"
      "sha256-UKN0UDZcBvmZ/9nSpcy4IOxIkL1PvOmC2w5bZpvk+L0=";

  mypy-boto3-application-insights =
    buildMypyBoto3Package "application-insights" "1.38.0"
      "sha256-k+SAev/fNpdjiFJzdUhkNrVny5QdYSIo4KbVocenouw=";

  mypy-boto3-applicationcostprofiler =
    buildMypyBoto3Package "applicationcostprofiler" "1.38.0"
      "sha256-nL3v4SApGOxhGcwq/9OyKhn+5X17tA3gCn5PZpwaaVs=";

  mypy-boto3-appmesh =
    buildMypyBoto3Package "appmesh" "1.38.0"
      "sha256-1YzBEenzkvMBprqh6YCp7ccqrwjPSt0j0cVxuXZd8iY=";

  mypy-boto3-apprunner =
    buildMypyBoto3Package "apprunner" "1.38.2"
      "sha256-GJTIrZNUiUwE1gJ46a5sy/GVwvned9bcGeWMWLraNgU=";

  mypy-boto3-appstream =
    buildMypyBoto3Package "appstream" "1.38.0"
      "sha256-0Ex+gq7lC3J1pxSpDZD6SJhxHnWosedNXMFMHdfG2Pc=";

  mypy-boto3-appsync =
    buildMypyBoto3Package "appsync" "1.38.2"
      "sha256-5hCTRhwqD1apJqpV/i2tLX09O6uA9Zn6c+gswBHO5H0=";

  mypy-boto3-arc-zonal-shift =
    buildMypyBoto3Package "arc-zonal-shift" "1.38.0"
      "sha256-ksKIbASQfKzf67Pkdv5HUipoep/8Qv7jVcjC4KCqAoI=";

  mypy-boto3-athena =
    buildMypyBoto3Package "athena" "1.38.13"
      "sha256-1Fonc55fVM8ksqCTBwXVHeqhypgsYegoW8PEEPqcTF4=";

  mypy-boto3-auditmanager =
    buildMypyBoto3Package "auditmanager" "1.38.22"
      "sha256-6OgMopfNAD7bpLnDFXlcejFqKYTOvrJOd/X39SHYa1A=";

  mypy-boto3-autoscaling =
    buildMypyBoto3Package "autoscaling" "1.38.0"
      "sha256-cktwW7m3hDjlGuli/kLnjup8v6+NMypkis1uwaMjDGw=";

  mypy-boto3-autoscaling-plans =
    buildMypyBoto3Package "autoscaling-plans" "1.38.0"
      "sha256-g+40VJVE4PQG5k1wjIFcEio5kyLpdaQzfSFp/ABEXh8=";

  mypy-boto3-backup =
    buildMypyBoto3Package "backup" "1.38.0"
      "sha256-XYfzsfQvrnPdBaA+C8t2LGaE9Y93DRUIsWVFylNz8VI=";

  mypy-boto3-backup-gateway =
    buildMypyBoto3Package "backup-gateway" "1.38.0"
      "sha256-z30tlyOFGYBz0IaEQ4RqSa5YPFZlRq9ulo32/N7ESbc=";

  mypy-boto3-batch =
    buildMypyBoto3Package "batch" "1.38.0"
      "sha256-/4QC6sHh97mwEnLonWyGaFqKbGtsk+2VGhvCeg2cLVA=";

  mypy-boto3-billingconductor =
    buildMypyBoto3Package "billingconductor" "1.38.0"
      "sha256-ok1DtHq4cuDge4oKpQTdf1zRD6wuHEdANRcTT4DhucY=";

  mypy-boto3-braket =
    buildMypyBoto3Package "braket" "1.38.0"
      "sha256-D6YNRjQeNVKBBaqpVYyx3k/YHD7CdxNtSV+DSSARdaw=";

  mypy-boto3-budgets =
    buildMypyBoto3Package "budgets" "1.38.0"
      "sha256-WXMpTKmBXa1q51tnLTE5sOxJyn0LLqOwpV2wdZfM1v0=";

  mypy-boto3-ce =
    buildMypyBoto3Package "ce" "1.38.24"
      "sha256-daz9r4KWlK/n3ZcxDRARlOlSKcUbhyW/12HPWja30RY=";

  mypy-boto3-chime =
    buildMypyBoto3Package "chime" "1.38.0"
      "sha256-11InpFlq1VttLR9gBHvuUxTEbim4kdDhilCfYalNlNs=";

  mypy-boto3-chime-sdk-identity =
    buildMypyBoto3Package "chime-sdk-identity" "1.38.0"
      "sha256-qqdaEYY9jHBPKLlRfzfPahvD1i3xZyp0r5eU+gZSdow=";

  mypy-boto3-chime-sdk-media-pipelines =
    buildMypyBoto3Package "chime-sdk-media-pipelines" "1.38.0"
      "sha256-L7YEHQnuVHvdJvtCGvQZtZVJmdqASXih6Q2mqvxQ15g=";

  mypy-boto3-chime-sdk-meetings =
    buildMypyBoto3Package "chime-sdk-meetings" "1.38.0"
      "sha256-1ikmW6i2DRdaHne8IRypCGkz2BOBdP8YciwVVbXUi0Q=";

  mypy-boto3-chime-sdk-messaging =
    buildMypyBoto3Package "chime-sdk-messaging" "1.38.0"
      "sha256-uAoK3VdspWeBXFrRA2TdrLfeirs5gzWF6U/mAoIxyYs=";

  mypy-boto3-chime-sdk-voice =
    buildMypyBoto3Package "chime-sdk-voice" "1.38.0"
      "sha256-tzYioIJx6aJQxiCUMOCQl71uzKW9f9kEw2xZlFrgfpI=";

  mypy-boto3-cleanrooms =
    buildMypyBoto3Package "cleanrooms" "1.38.6"
      "sha256-1OGeYcLRpFeLfnxKEjSUPfPI6keLDJbZVvhNXq12OaA=";

  mypy-boto3-cloud9 =
    buildMypyBoto3Package "cloud9" "1.38.0"
      "sha256-1CpaQ6Xr+b5WirD6GIjwRzMXmjH2cJPt0t1FEV/8Wr4=";

  mypy-boto3-cloudcontrol =
    buildMypyBoto3Package "cloudcontrol" "1.38.0"
      "sha256-MQioeShh5xWsGdIqMqqrgOPpVZxvkwP0ZFdkLkcMjOE=";

  mypy-boto3-clouddirectory =
    buildMypyBoto3Package "clouddirectory" "1.38.0"
      "sha256-E/vP9Z9Cd6QZDJ2es245eXiUjTSsV1XNN9qNnIbXJ7E=";

  mypy-boto3-cloudformation =
    buildMypyBoto3Package "cloudformation" "1.38.0"
      "sha256-VjOZFmwH6R4GlfseWBA6JIsr7g214sPwcVV3bdYxGAU=";

  mypy-boto3-cloudfront =
    buildMypyBoto3Package "cloudfront" "1.38.12"
      "sha256-2ilPIDK1bdMkn69PXs2Q4HUhfG67XWjPWZHPr9ZyXvs=";

  mypy-boto3-cloudhsm =
    buildMypyBoto3Package "cloudhsm" "1.38.0"
      "sha256-ViUiSTA6bTP3IYeKQ1CHd0yZO4MhX2ovADA3lHEwtzs=";

  mypy-boto3-cloudhsmv2 =
    buildMypyBoto3Package "cloudhsmv2" "1.38.0"
      "sha256-mtbsRBR8ouk7Jr2KDgbGWkMhagS1nynRpivhfPPRSQQ=";

  mypy-boto3-cloudsearch =
    buildMypyBoto3Package "cloudsearch" "1.38.0"
      "sha256-7VFGXVyM3VyFXlgo6Fc0tYLWM5T0F6QotORgTUSN4gg=";

  mypy-boto3-cloudsearchdomain =
    buildMypyBoto3Package "cloudsearchdomain" "1.38.0"
      "sha256-YpciSNXGJznUocicc/2Yw3DPbBd75hysRiRQz8aCMHM=";

  mypy-boto3-cloudtrail =
    buildMypyBoto3Package "cloudtrail" "1.38.0"
      "sha256-YF6b1GuGRcUxY+5RICiH6V12DoDxjLq6lyrjItqfNQk=";

  mypy-boto3-cloudtrail-data =
    buildMypyBoto3Package "cloudtrail-data" "1.38.0"
      "sha256-fAf1+/UqJJ3Ya88/HHoeRd/KalfOTFJKjk2xypF3Dko=";

  mypy-boto3-cloudwatch =
    buildMypyBoto3Package "cloudwatch" "1.38.21"
      "sha256-2fJzoFoENNelKUzoHz1F30azqv7DrujQsGWoIWopAHY=";

  mypy-boto3-codeartifact =
    buildMypyBoto3Package "codeartifact" "1.38.0"
      "sha256-II4WIgBsWK3+CXk/XFzWpmlEXsbBuWt4C3onExl2u0o=";

  mypy-boto3-codebuild =
    buildMypyBoto3Package "codebuild" "1.38.17"
      "sha256-QnIaGy8R8HAt69dK9+iJfOwyQTIv0Dl9hI12GXlsFlg=";

  mypy-boto3-codecatalyst =
    buildMypyBoto3Package "codecatalyst" "1.38.0"
      "sha256-KaRBeshwi+J7KfGGI6IGjXRSHohzCKDYs1ItibBAjSc=";

  mypy-boto3-codecommit =
    buildMypyBoto3Package "codecommit" "1.38.0"
      "sha256-rqWKQdiTcuYwqc/WY89k/MiDfYhgnSZWkcXnJiD/9+8=";

  mypy-boto3-codedeploy =
    buildMypyBoto3Package "codedeploy" "1.38.0"
      "sha256-N5OGxXiiKb0BkwoGp+UrxBEuFI3dhNcsCblfoaEHDxg=";

  mypy-boto3-codeguru-reviewer =
    buildMypyBoto3Package "codeguru-reviewer" "1.38.0"
      "sha256-bPuVGpYxPKkOjNRTD0ONckRIGiHYBhEz8QGR31rFFB4=";

  mypy-boto3-codeguru-security =
    buildMypyBoto3Package "codeguru-security" "1.38.0"
      "sha256-wpPaizIA6NU1EXKEzrWww6636iXON2Qr0v7v9MohkIk=";

  mypy-boto3-codeguruprofiler =
    buildMypyBoto3Package "codeguruprofiler" "1.38.0"
      "sha256-twmdIgbVpRFwUcRu0Kyoti+Y1KCPmRgaCsf6Kozhmg8=";

  mypy-boto3-codepipeline =
    buildMypyBoto3Package "codepipeline" "1.38.18"
      "sha256-C++b8vPawYw1J2nsjf0b2brkHQfAeT10zsaO9molFgk=";

  mypy-boto3-codestar =
    buildMypyBoto3Package "codestar" "1.35.0"
      "sha256-B9Aq+hh9BOzCIYMkS21IZYb3tNCnKnV2OpSIo48aeJM=";

  mypy-boto3-codestar-connections =
    buildMypyBoto3Package "codestar-connections" "1.38.0"
      "sha256-xv85IiUoOprlI7Rb7+dn6+Jo9oxuBZgV4m58FIYR6Yk=";

  mypy-boto3-codestar-notifications =
    buildMypyBoto3Package "codestar-notifications" "1.38.0"
      "sha256-VRjRhKcPZrZl5tY6q7AMBjIEnp9Zcj61/ZkliNMb1f0=";

  mypy-boto3-cognito-identity =
    buildMypyBoto3Package "cognito-identity" "1.38.0"
      "sha256-Uek62hNK0eJRxRj9YiU4R44w33IUyrXZ9AyGbEcoiyc=";

  mypy-boto3-cognito-idp =
    buildMypyBoto3Package "cognito-idp" "1.38.16"
      "sha256-2IExKWR4xOJkI+HHJMemU88PoBsi5lzkTq03cUhFLv0=";

  mypy-boto3-cognito-sync =
    buildMypyBoto3Package "cognito-sync" "1.38.0"
      "sha256-slpa2Wj3OnMko88okoP6eRaZ8Bzdsnqt4HV5MPuvuCo=";

  mypy-boto3-comprehend =
    buildMypyBoto3Package "comprehend" "1.38.0"
      "sha256-J8e5j7Xs7W4HpbC7FxF1BnssPA1rOgTHjwZHTdepUlQ=";

  mypy-boto3-comprehendmedical =
    buildMypyBoto3Package "comprehendmedical" "1.38.0"
      "sha256-VPJP8laiJsNC/uxn/K2jaH2jrQWfltP46xLJEg1erx0=";

  mypy-boto3-compute-optimizer =
    buildMypyBoto3Package "compute-optimizer" "1.38.0"
      "sha256-DNpcAOVA9BvJDK/ZnCUF/iXJrQM7nxQB0YkH1DkWgQs=";

  mypy-boto3-config =
    buildMypyBoto3Package "config" "1.38.0"
      "sha256-GaC5ClnSfg8/8jCv2ropPoUS7YOIhKkyicDhsYUUPwk=";

  mypy-boto3-connect =
    buildMypyBoto3Package "connect" "1.38.7"
      "sha256-Aq0JiXGaBHSN31Z72a0LL8jG25f+0dBIlIWZuCergV4=";

  mypy-boto3-connect-contact-lens =
    buildMypyBoto3Package "connect-contact-lens" "1.38.0"
      "sha256-IUoOWTLafI4fQhyvE5CoJPzTRp9o6NxMYSmyqqkzmno=";

  mypy-boto3-connectcampaigns =
    buildMypyBoto3Package "connectcampaigns" "1.38.0"
      "sha256-gHdrftxNKa7bI9AzBXKWKiwBQ5kK158LZx9peThWzGA=";

  mypy-boto3-connectcases =
    buildMypyBoto3Package "connectcases" "1.38.5"
      "sha256-rinS6qpL1ZXCqtFw2auPusw6460M2zXYOfq7B2x5vSA=";

  mypy-boto3-connectparticipant =
    buildMypyBoto3Package "connectparticipant" "1.38.0"
      "sha256-ABRIC59mat4ek0yrWxcHUr62whXmaZef47yDR7A2rl0=";

  mypy-boto3-controltower =
    buildMypyBoto3Package "controltower" "1.38.17"
      "sha256-RtmXag1W6xxWlr9FZsIf8YtBeJoL91Ssflck/Ok1C3Q=";

  mypy-boto3-cur =
    buildMypyBoto3Package "cur" "1.38.0"
      "sha256-lurpm+SfLFZKROAdMiPhthRnaihxDXTLO296JUQSbYc=";

  mypy-boto3-customer-profiles =
    buildMypyBoto3Package "customer-profiles" "1.38.0"
      "sha256-EuS4aLejTOf1w1mkx1Yp9Rj2Dy10Rcrcrwnfe25/5cM=";

  mypy-boto3-databrew =
    buildMypyBoto3Package "databrew" "1.38.0"
      "sha256-du5cZjwXzIW8FP2N7e9Ob9Cm9pPlReSY65EQkfsa+bg=";

  mypy-boto3-dataexchange =
    buildMypyBoto3Package "dataexchange" "1.38.0"
      "sha256-0ys8v/ATJ7c0+MJoAiSqIBoCcgO022HB9C/Jg7vFgNc=";

  mypy-boto3-datapipeline =
    buildMypyBoto3Package "datapipeline" "1.38.0"
      "sha256-BpMkYM5+cchfhg+xJR9/cXd75fzl44rwsXXEe5ofowU=";

  mypy-boto3-datasync =
    buildMypyBoto3Package "datasync" "1.38.20"
      "sha256-/tlmBxr4MvI1YuPq5+BgHzQj2J+c1nN/C/poOxE0Xd8=";

  mypy-boto3-dax =
    buildMypyBoto3Package "dax" "1.38.0"
      "sha256-uWL44n7FjT+BKuiJ2rbsg65x0kfxV4IdOAoLmrbeK5E=";

  mypy-boto3-detective =
    buildMypyBoto3Package "detective" "1.38.0"
      "sha256-vkRJVKcgvG0sZBoRAuHfSB3XiOAi5yNqLH0FRRjTRhg=";

  mypy-boto3-devicefarm =
    buildMypyBoto3Package "devicefarm" "1.38.9"
      "sha256-nb+AiG24s1vyTXwf2wwJlusMd1qvilQOd1mKY2tO0Lk=";

  mypy-boto3-devops-guru =
    buildMypyBoto3Package "devops-guru" "1.38.0"
      "sha256-AmGjovRrT72M3jpgqAJtDBYH7y0NMFj7Wm/CffaDZPA=";

  mypy-boto3-directconnect =
    buildMypyBoto3Package "directconnect" "1.38.0"
      "sha256-IjjwUYsedHs2o02FrzBRoXUDdKpo9RPpN0luOTTmbfA=";

  mypy-boto3-discovery =
    buildMypyBoto3Package "discovery" "1.38.0"
      "sha256-RxMknfFc0n4Sb/dZ9CfE7/B7je44gAoObZFPbho+rr8=";

  mypy-boto3-dlm =
    buildMypyBoto3Package "dlm" "1.38.0"
      "sha256-mFFkE37/+8k+YZ4ZJdg3QiFN2bkqArnSmjoCWdxMJ4c=";

  mypy-boto3-dms =
    buildMypyBoto3Package "dms" "1.38.17"
      "sha256-fGqy3xSfdZPi4BX9o+nqjAQzSnx64y1PllxB6j+4ISY=";

  mypy-boto3-docdb =
    buildMypyBoto3Package "docdb" "1.38.0"
      "sha256-R8SEBFjllZcR7UiHgXdIldToRjp+YF4F6xthaCzvi5Y=";

  mypy-boto3-docdb-elastic =
    buildMypyBoto3Package "docdb-elastic" "1.38.0"
      "sha256-JeQKgthsFsV2g24kONZEucEfZ7vY8UC4hKNwFO2o5LI=";

  mypy-boto3-drs =
    buildMypyBoto3Package "drs" "1.38.0"
      "sha256-MZJRRdZ2nTX+EceiW5gEroB+FcGNBwHug16IRWk6lhY=";

  mypy-boto3-ds =
    buildMypyBoto3Package "ds" "1.38.8"
      "sha256-xDe+kWl/+j9ruKrlNLT20jv2WbJvChMkIrrkH3JIXOY=";

  mypy-boto3-dynamodb =
    buildMypyBoto3Package "dynamodb" "1.38.4"
      "sha256-XPN4djHjErPXX4mmy7vUrXhqdvXVZa8CP+vwP78jwLU=";

  mypy-boto3-dynamodbstreams =
    buildMypyBoto3Package "dynamodbstreams" "1.38.0"
      "sha256-vUQbKxHwgpzzZVHVhkxs5F02qGajngs3OsxqBD3sGMA=";

  mypy-boto3-ebs =
    buildMypyBoto3Package "ebs" "1.38.0"
      "sha256-RQh46jrXqj4bXTRJ+tPR9sql7yUn7Ek9u4p0OU0A7b0=";

  mypy-boto3-ec2 =
    buildMypyBoto3Package "ec2" "1.38.25"
      "sha256-rtfXRsfGr34/dUJK1kgpp85blNyHERSkScQDraIpVMs=";

  mypy-boto3-ec2-instance-connect =
    buildMypyBoto3Package "ec2-instance-connect" "1.38.0"
      "sha256-1zg5Vw+V+bpp5FxTw0CSfxSN7JNVBwY4I8uDFhEJL3w=";

  mypy-boto3-ecr =
    buildMypyBoto3Package "ecr" "1.38.6"
      "sha256-CTIvlIYRlak6FnjhbyyShNGtYbRk45/ESXEKIoR7q/I=";

  mypy-boto3-ecr-public =
    buildMypyBoto3Package "ecr-public" "1.38.6"
      "sha256-aSZu8mxsTho4pvWWbNwlJf0IROjqjTlIUEE5DJkAje4=";

  mypy-boto3-ecs =
    buildMypyBoto3Package "ecs" "1.38.18"
      "sha256-UjzMLvaDYVIrmHDFO/TlyofiwRqGlHA+aDqWcRepHdI=";

  mypy-boto3-efs =
    buildMypyBoto3Package "efs" "1.38.0"
      "sha256-Z2LMQFtcTNqxsoWKGg4iBFtbwnXGVVXQrRa/bZdnl40=";

  mypy-boto3-eks =
    buildMypyBoto3Package "eks" "1.38.0"
      "sha256-Z2TfCH3Prd6E9SkUXRKrHApw2uwnmSZWGxlphcI5i2U=";

  mypy-boto3-elastic-inference =
    buildMypyBoto3Package "elastic-inference" "1.36.0"
      "sha256-duU3LIeW3FNiplVmduZsNXBoDK7vbO6ecrBt1Y7C9rU=";

  mypy-boto3-elasticache =
    buildMypyBoto3Package "elasticache" "1.38.0"
      "sha256-siQkDuqc8qYpD7OkmRwsKDH1T5OQIfSxvrak/VfvwQ4=";

  mypy-boto3-elasticbeanstalk =
    buildMypyBoto3Package "elasticbeanstalk" "1.38.0"
      "sha256-oqjyD+OlTHxrUenbecGYt8GjXHoip07zsgbb+siCUqw=";

  mypy-boto3-elastictranscoder =
    buildMypyBoto3Package "elastictranscoder" "1.38.0"
      "sha256-RhnEiyQBYzORnzvPZH6UCfZa6zPf82P+9AovEeff9GM=";

  mypy-boto3-elb =
    buildMypyBoto3Package "elb" "1.38.0"
      "sha256-vv3PDyswaI9sLKlPoXGngDMh3SIAy8cWCKaVzEUCb7o=";

  mypy-boto3-elbv2 =
    buildMypyBoto3Package "elbv2" "1.38.0"
      "sha256-bGXPSBRUfkiRc2Isx79953gV2qv2rCE9N+L11CEceug=";

  mypy-boto3-emr =
    buildMypyBoto3Package "emr" "1.38.18"
      "sha256-q/1574BCv6rcHog3kEXBFr0K0FNrqE3nj0JTfCTsC8A=";

  mypy-boto3-emr-containers =
    buildMypyBoto3Package "emr-containers" "1.38.0"
      "sha256-Lr2cpSBkWl30iIS3fc4qiOWBTbIu5L0MMW5O9Au+COM=";

  mypy-boto3-emr-serverless =
    buildMypyBoto3Package "emr-serverless" "1.38.0"
      "sha256-WxLk2ka6qnoynRbOQcXAEv84896eFOY4AYApw3c+ZlA=";

  mypy-boto3-entityresolution =
    buildMypyBoto3Package "entityresolution" "1.38.0"
      "sha256-U7q6B2Bh/5J3WBB0CmUJbNBFa+d28FYTsGiabMA5Kjc=";

  mypy-boto3-es =
    buildMypyBoto3Package "es" "1.38.0"
      "sha256-u6EpWVFrrL7BCeaBdRCvY33m46fj8qQX8uNYRZfsUOI=";

  mypy-boto3-events =
    buildMypyBoto3Package "events" "1.38.25"
      "sha256-7Qy4CTzuWYTg2DF4odirHVLfwx4a1BVtJ62jcAlNDoY=";

  mypy-boto3-evidently =
    buildMypyBoto3Package "evidently" "1.38.0"
      "sha256-TLZMEZh23sUK4Pmd+AJ7m0aQFlw3v/XQK2xWb1xHF/Y=";

  mypy-boto3-finspace =
    buildMypyBoto3Package "finspace" "1.38.0"
      "sha256-ubK2DXl4Cb6dADV4bAyjJYww0OqaAOwtIkt0HY46rZk=";

  mypy-boto3-finspace-data =
    buildMypyBoto3Package "finspace-data" "1.38.0"
      "sha256-0Ln8pT0rhaR4xXe4gLPKQWuzuq2WJ1IyhvpUf3YKehM=";

  mypy-boto3-firehose =
    buildMypyBoto3Package "firehose" "1.38.16"
      "sha256-IL9bOLR3F7TMmJr/MUVBAQVOmZ8Bp/1cWOvMxEFzbUU=";

  mypy-boto3-fis =
    buildMypyBoto3Package "fis" "1.38.0"
      "sha256-fdg4ZXLqmI8HNrgw6brsOzvTg/YicwyRuQcePguzcPA=";

  mypy-boto3-fms =
    buildMypyBoto3Package "fms" "1.38.0"
      "sha256-iz+bYbcULRebiv5RCJNIaGXjyxz9mSyyo0ybsiLQJBw=";

  mypy-boto3-forecast =
    buildMypyBoto3Package "forecast" "1.38.0"
      "sha256-9In2nEPnoxv5HGF9/2Nr7t1Jy7NCJ24dwKRSTC7Aygc=";

  mypy-boto3-forecastquery =
    buildMypyBoto3Package "forecastquery" "1.38.0"
      "sha256-L0TRWllDLxkN8Ep4Rn6HEi8bI7sAYts8uUD098I5t70=";

  mypy-boto3-frauddetector =
    buildMypyBoto3Package "frauddetector" "1.38.0"
      "sha256-t1Pj8GSr9XDym/s1qAXaiGSGWEEttDhjBnPrB/L6Lwo=";

  mypy-boto3-fsx =
    buildMypyBoto3Package "fsx" "1.38.0"
      "sha256-lDGC5LuanclpzeDgrQ9bApm3BFzG3sANnFvchVM48UQ=";

  mypy-boto3-gamelift =
    buildMypyBoto3Package "gamelift" "1.38.0"
      "sha256-5b65h5uXhHrRjL8uuEntAePWyv5j2WMjxjRiMkNtgfo=";

  mypy-boto3-glacier =
    buildMypyBoto3Package "glacier" "1.38.0"
      "sha256-fFCo7FH66z7YG4f8O7Whl01/kGSZVZ0MS4FTIEmDpaM=";

  mypy-boto3-globalaccelerator =
    buildMypyBoto3Package "globalaccelerator" "1.38.0"
      "sha256-abALPaOoxM8dvwqd8j41mTT1Zmcn/sEVzlopSMc+fYM=";

  mypy-boto3-glue =
    buildMypyBoto3Package "glue" "1.38.22"
      "sha256-qcUp+vqqmEXTnDIEs/tsu7Yz+nR/r2oISisqOB7xKis=";

  mypy-boto3-grafana =
    buildMypyBoto3Package "grafana" "1.38.0"
      "sha256-SH8Rq6E6C0W8AvUqJCQZCpeFnw4HMepev5jjV4uDlkc=";

  mypy-boto3-greengrass =
    buildMypyBoto3Package "greengrass" "1.38.0"
      "sha256-Ir/Blf+1utiGwGK8AZ+XssqLpBO31AxhHjRuIgOwlq0=";

  mypy-boto3-greengrassv2 =
    buildMypyBoto3Package "greengrassv2" "1.38.0"
      "sha256-M15Zykr8VoNTAlJzM2SvRQZtfRyy0COlZhbVBo335cs=";

  mypy-boto3-groundstation =
    buildMypyBoto3Package "groundstation" "1.38.0"
      "sha256-GkC4iF96d4nQMNZZx2JHBvgdFvzqujmH2YLzEuiM1n8=";

  mypy-boto3-guardduty =
    buildMypyBoto3Package "guardduty" "1.38.12"
      "sha256-mKzD4xUXunOsxxTXJIoV0ardgVkhvr57KqRLxj2KhPk=";

  mypy-boto3-health =
    buildMypyBoto3Package "health" "1.38.0"
      "sha256-3LAT8F0uRrOVooWD6DdJaeYN9MRfOWEy7Ko19osn050=";

  mypy-boto3-healthlake =
    buildMypyBoto3Package "healthlake" "1.38.0"
      "sha256-z839V1DLHxIkZrSjzWpLbAMGszL3UokIHAHwaVFhSDQ=";

  mypy-boto3-iam =
    buildMypyBoto3Package "iam" "1.38.14"
      "sha256-RpIgAHS/kX2nySN7LFC7uXGJMcn5m3PleezdEAtlgqM=";

  mypy-boto3-identitystore =
    buildMypyBoto3Package "identitystore" "1.38.0"
      "sha256-n11mu3O2o2sPL13xPtwlWVvpNfVUdV7l7NO2lXg+ZyM=";

  mypy-boto3-imagebuilder =
    buildMypyBoto3Package "imagebuilder" "1.38.11"
      "sha256-GjIDucUtcb+AP1Y9FeS8wbLOJbnZXMXtJiQkZJGWVdo=";

  mypy-boto3-importexport =
    buildMypyBoto3Package "importexport" "1.38.0"
      "sha256-1wv4Ld1ELjKflpwAEfpKY0bf9ktdrmeJuSo8MXr+PNM=";

  mypy-boto3-inspector =
    buildMypyBoto3Package "inspector" "1.38.0"
      "sha256-MaOetVmIqI8vVaVt6HCUXxrLO7lUm4i5DDzwfxEdLIg=";

  mypy-boto3-inspector2 =
    buildMypyBoto3Package "inspector2" "1.38.20"
      "sha256-Yz+NR/OXOQeeQROMuxGKSY85Z8wrS7TCg1KeUGg7k0c=";

  mypy-boto3-internetmonitor =
    buildMypyBoto3Package "internetmonitor" "1.38.0"
      "sha256-MeTys5uEMqMNVUsXNqHpK4kb4Vo+VkDsSs/1NnnR+Og=";

  mypy-boto3-iot =
    buildMypyBoto3Package "iot" "1.38.0"
      "sha256-7cn53QQLkbTsyVtACvPRuFFeFdWi8AET7/9cfbRx4TE=";

  mypy-boto3-iot-data =
    buildMypyBoto3Package "iot-data" "1.38.0"
      "sha256-H/4LmmUCRJ3Dl88krxbLi/piJJmzMh3E5KHkxQ/7/X0=";

  mypy-boto3-iot-jobs-data =
    buildMypyBoto3Package "iot-jobs-data" "1.38.0"
      "sha256-iBhisrCiSkwAveupk0ce/vgRXb71a+mmssxc2mhv1aU=";

  mypy-boto3-iot1click-devices =
    buildMypyBoto3Package "iot1click-devices" "1.35.93"
      "sha256-fwfuhSitYIJW5QswYdZ8ZpNL3AEg6MXhJitbbU48STs=";

  mypy-boto3-iot1click-projects =
    buildMypyBoto3Package "iot1click-projects" "1.35.93"
      "sha256-LFuz5/nCZGpSfgqyswxn80VzxXsqzZlBFqPtPJ8bzgo=";

  mypy-boto3-iotanalytics =
    buildMypyBoto3Package "iotanalytics" "1.38.0"
      "sha256-ES6vvrN7Nevm6TOsMponRSIMMl3JwdFIJM9O+l4q0fg=";

  mypy-boto3-iotdeviceadvisor =
    buildMypyBoto3Package "iotdeviceadvisor" "1.38.0"
      "sha256-6j+b1cBc/F4ASlUjvyVdNnPLbHzX0Nhvym2qIPQMvHg=";

  mypy-boto3-iotevents =
    buildMypyBoto3Package "iotevents" "1.38.0"
      "sha256-etL5deyRFtlpPO451sLVOuKo8xmZkivSAupduSkWw0Y=";

  mypy-boto3-iotevents-data =
    buildMypyBoto3Package "iotevents-data" "1.38.0"
      "sha256-knt/F/5O/3RbqQCJ+neDXXWfX7AdE6ZyGaf9vTGMHmI=";

  mypy-boto3-iotfleethub =
    buildMypyBoto3Package "iotfleethub" "1.38.0"
      "sha256-UZJF85qGP/D4wyz9eofV/EHASzjQ/g/iJoG1P61Nnm0=";

  mypy-boto3-iotfleetwise =
    buildMypyBoto3Package "iotfleetwise" "1.38.0"
      "sha256-hSfdI4iRL7nVZYDAXRQCodQcTfZXx9cndHOQd9I/2w4=";

  mypy-boto3-iotsecuretunneling =
    buildMypyBoto3Package "iotsecuretunneling" "1.38.0"
      "sha256-6avzbW+so4IuyVHTy7LzP/I2rcxphA5+w8zmC+kWFzg=";

  mypy-boto3-iotsitewise =
    buildMypyBoto3Package "iotsitewise" "1.38.0"
      "sha256-i7cDo9r2H/dp+asnUx/7jP+IkMN/mLPf2mNPpVj/SrQ=";

  mypy-boto3-iotthingsgraph =
    buildMypyBoto3Package "iotthingsgraph" "1.38.0"
      "sha256-669dMXgGxpyLAYXwok/IenBzYQ18+Ii+ZbN2LHjXqGQ=";

  mypy-boto3-iottwinmaker =
    buildMypyBoto3Package "iottwinmaker" "1.38.0"
      "sha256-Jn2nGSCWDLhajLbd+PhKpeP0czaWvTZA0iWguWUPsk0=";

  mypy-boto3-iotwireless =
    buildMypyBoto3Package "iotwireless" "1.38.0"
      "sha256-a/BCXDBZ3iKLSs/D8ZhGf4zC/HWiBEUbiV0TfQrtLjo=";

  mypy-boto3-ivs =
    buildMypyBoto3Package "ivs" "1.38.0"
      "sha256-FdGvtAvQGv9Aqho48WB/6+LYchVetmrjQ0i/GJrdvx4=";

  mypy-boto3-ivs-realtime =
    buildMypyBoto3Package "ivs-realtime" "1.38.0"
      "sha256-l8fDX2Dy1+SV0YUKs1g5AO4UcETibLAuuRFyfSpiWgo=";

  mypy-boto3-ivschat =
    buildMypyBoto3Package "ivschat" "1.38.0"
      "sha256-SAboAGtNQSMgatVWhU5ySzwLFpZNIpVpLkls1Z4mjys=";

  mypy-boto3-kafka =
    buildMypyBoto3Package "kafka" "1.38.0"
      "sha256-ZxEQat43fzoNe+2J0uLY3xSE32MRWbLHZkNJHyDX484=";

  mypy-boto3-kafkaconnect =
    buildMypyBoto3Package "kafkaconnect" "1.38.0"
      "sha256-u7FSXllB5nchYMgI0nMS+eFYIWbAwcO/P1PicInsidE=";

  mypy-boto3-kendra =
    buildMypyBoto3Package "kendra" "1.38.0"
      "sha256-U4RwVi2v0RDHB5RB4lWIDIpNH7zK3QbnedloMnoG8mc=";

  mypy-boto3-kendra-ranking =
    buildMypyBoto3Package "kendra-ranking" "1.38.0"
      "sha256-BbUpFRwYYBkHUBPC8Q6zltxzSDEBnB9LaQxDeiMOFZA=";

  mypy-boto3-keyspaces =
    buildMypyBoto3Package "keyspaces" "1.38.0"
      "sha256-/p6IadhTa59EpFXgN3GexAL+qLJzkedRFHfMOteVIeY=";

  mypy-boto3-kinesis =
    buildMypyBoto3Package "kinesis" "1.38.8"
      "sha256-OTLHfz/Iw3VFTz36ceHi8YVF2VyFTatX3Jw7prVh2Sg=";

  mypy-boto3-kinesis-video-archived-media =
    buildMypyBoto3Package "kinesis-video-archived-media" "1.38.0"
      "sha256-cK23oSB+hPQBiUb5AfINbkSHvSwIwq4stJpFHjuUtWI=";

  mypy-boto3-kinesis-video-media =
    buildMypyBoto3Package "kinesis-video-media" "1.38.0"
      "sha256-huCu3M4LCwjm9X780J7+vl84IYHLeweG3ir1y3rrYXE=";

  mypy-boto3-kinesis-video-signaling =
    buildMypyBoto3Package "kinesis-video-signaling" "1.38.0"
      "sha256-DgbOnLFPNdo8sdNSitsnbkJwAb3ykkII4MwU9JmU9kA=";

  mypy-boto3-kinesis-video-webrtc-storage =
    buildMypyBoto3Package "kinesis-video-webrtc-storage" "1.38.0"
      "sha256-qGj4MXzX5j1J0lVh9SjGLa7mvtMAiMHyr/j36mVEBT4=";

  mypy-boto3-kinesisanalytics =
    buildMypyBoto3Package "kinesisanalytics" "1.38.0"
      "sha256-bvFnGeJClCz/oDxjDSER6GupFZgF6fzGMPZL6f8MJRc=";

  mypy-boto3-kinesisanalyticsv2 =
    buildMypyBoto3Package "kinesisanalyticsv2" "1.38.0"
      "sha256-fsCIR+cwXiEdzdgQTB2OPZHbc/+DLZfVLB2THYjxhSo=";

  mypy-boto3-kinesisvideo =
    buildMypyBoto3Package "kinesisvideo" "1.38.0"
      "sha256-PKOF/jd1Wjz8lCwbCd4cfHeStkvcDhQu7a7bpHaizgU=";

  mypy-boto3-kms =
    buildMypyBoto3Package "kms" "1.38.0"
      "sha256-s1D6mzq5T7G8jm2nxUr7Kq6QeT3oDBOF4yafahD+fq4=";

  mypy-boto3-lakeformation =
    buildMypyBoto3Package "lakeformation" "1.38.0"
      "sha256-CTJpnW+pjNAr6U91P8A0JdEjFzAc31NGKb40fxYjhSQ=";

  mypy-boto3-lambda =
    buildMypyBoto3Package "lambda" "1.38.0"
      "sha256-7OezhIwEXhvoHE8rdIIALBfOfLcN6FBmEUYQOoyxo/s=";

  mypy-boto3-lex-models =
    buildMypyBoto3Package "lex-models" "1.38.0"
      "sha256-byS+HVn7NVfUH0zLOkyIF5Y91dgBA2LufOXz6uklH2c=";

  mypy-boto3-lex-runtime =
    buildMypyBoto3Package "lex-runtime" "1.38.0"
      "sha256-12bGsyu0uvqnMuorgXXItDKd7UU72/a6WMKbY3eDHi4=";

  mypy-boto3-lexv2-models =
    buildMypyBoto3Package "lexv2-models" "1.38.0"
      "sha256-vmlwTsR2rQe3LzoeQKJhFrWxvID2xyhkdzcvxMn4Iq0=";

  mypy-boto3-lexv2-runtime =
    buildMypyBoto3Package "lexv2-runtime" "1.38.0"
      "sha256-hHMZReLH2J2vgdkECWREXAp/2ZOoJSynZU8epapC188=";

  mypy-boto3-license-manager =
    buildMypyBoto3Package "license-manager" "1.38.15"
      "sha256-2zkjzEgJC9wzLiCTUU5XB3YXcX2OVeb8oOvpI/ITiaQ=";

  mypy-boto3-license-manager-linux-subscriptions =
    buildMypyBoto3Package "license-manager-linux-subscriptions" "1.38.0"
      "sha256-vCGJdlOkvJJqcVuG6Xw4LbTBkMOL1I6IZDEi7UyzLWU=";

  mypy-boto3-license-manager-user-subscriptions =
    buildMypyBoto3Package "license-manager-user-subscriptions" "1.38.0"
      "sha256-4E/TJK5iWaQ/dT08TbMa9ebeCBG2nLu1gzNb1yfu5x0=";

  mypy-boto3-lightsail =
    buildMypyBoto3Package "lightsail" "1.38.0"
      "sha256-CDM5XoPpt5frDiqH3pxG1Ve6GoucBAPH1pB6TPiRdv4=";

  mypy-boto3-location =
    buildMypyBoto3Package "location" "1.38.0"
      "sha256-uypKW3Cqj98SLeWmSwCXVKhKpXWXEvwdUexqqFgXeEc=";

  mypy-boto3-logs =
    buildMypyBoto3Package "logs" "1.38.16"
      "sha256-TE/PCNUYLj55t7JbGdv0UZ3OUvx0IgpYrL5b22KEnfM=";

  mypy-boto3-lookoutequipment =
    buildMypyBoto3Package "lookoutequipment" "1.38.0"
      "sha256-coTY1FRB1kmAFLvHXUCtD04LlISTaGeIFcCe0Huxg1U=";

  mypy-boto3-lookoutmetrics =
    buildMypyBoto3Package "lookoutmetrics" "1.38.0"
      "sha256-4K/PShc+lka6SXq76+0/EMNJyKH016bipkGw0U8Ty18=";

  mypy-boto3-lookoutvision =
    buildMypyBoto3Package "lookoutvision" "1.38.0"
      "sha256-1WWNqiCegFRTiDNLkMY7aTf/71/wyLRJwrspXg5M9KI=";

  mypy-boto3-m2 =
    buildMypyBoto3Package "m2" "1.38.0"
      "sha256-mj4MDgNiOIlfV1fdCQY2QZZ36YtXtHB0uzrM9nnaEKU=";

  mypy-boto3-machinelearning =
    buildMypyBoto3Package "machinelearning" "1.38.0"
      "sha256-t1mODXckbAj91pikYQtQobMq3xxYj7qJobOC68nMwEY=";

  mypy-boto3-macie2 =
    buildMypyBoto3Package "macie2" "1.38.0"
      "sha256-DCkWeZKd0Rql62rzEcAoCHxtqwlgBBdXURLVOcvyPRY=";

  mypy-boto3-managedblockchain =
    buildMypyBoto3Package "managedblockchain" "1.38.0"
      "sha256-S6cZnTw+8jRFjkrOcCoHCvIlqeLlkROEAlaX9EnnEkg=";

  mypy-boto3-managedblockchain-query =
    buildMypyBoto3Package "managedblockchain-query" "1.38.0"
      "sha256-b9t29BqBHshYWb9g/GD6no1NXYVmsjwY6knE8cIZBEA=";

  mypy-boto3-marketplace-catalog =
    buildMypyBoto3Package "marketplace-catalog" "1.38.0"
      "sha256-thLr5C7nCa4NyRHIVIFGwWAfl572eUJ4Z7P22s52BDc=";

  mypy-boto3-marketplace-entitlement =
    buildMypyBoto3Package "marketplace-entitlement" "1.38.0"
      "sha256-CA0TK1bvPo8+A5ltRwDzka1JIBZHQh1W/7UcZCfj550=";

  mypy-boto3-marketplacecommerceanalytics =
    buildMypyBoto3Package "marketplacecommerceanalytics" "1.38.0"
      "sha256-umSucGwSnfOwHbi+ywjTKO6Tvqv1buUI7InHy87KH7Y=";

  mypy-boto3-mediaconnect =
    buildMypyBoto3Package "mediaconnect" "1.38.0"
      "sha256-F6Yv7tgHnzgsekH7HJ8s7/Kpq1JiZkHs+qZEez5snUI=";

  mypy-boto3-mediaconvert =
    buildMypyBoto3Package "mediaconvert" "1.38.16"
      "sha256-13hTO6ZkJl+6IuEjJFl4Yy0McVURcRxfeefzgPnrULs=";

  mypy-boto3-medialive =
    buildMypyBoto3Package "medialive" "1.38.14"
      "sha256-AG2+2CVchluScgVnd8sPU3EpVyDcSmJ3HXxFVlU66Yw=";

  mypy-boto3-mediapackage =
    buildMypyBoto3Package "mediapackage" "1.38.0"
      "sha256-U5oU5PQrPaZf/9AVsxW7AHEbBlPedxJ/zJ24oyFqAp4=";

  mypy-boto3-mediapackage-vod =
    buildMypyBoto3Package "mediapackage-vod" "1.38.0"
      "sha256-QKKwwaJJ7o/FEWPQpLT7yMapG5DR6bn3UTt5XcMlN9A=";

  mypy-boto3-mediapackagev2 =
    buildMypyBoto3Package "mediapackagev2" "1.38.19"
      "sha256-XgeZlI03x32rfCt02ozAxWLOe6CBV+6qzgKhxkC6pc8=";

  mypy-boto3-mediastore =
    buildMypyBoto3Package "mediastore" "1.38.0"
      "sha256-4d8sOMV4pw8CWK9K3iFeaZKdccr0MQAminBCVFL4Ik0=";

  mypy-boto3-mediastore-data =
    buildMypyBoto3Package "mediastore-data" "1.38.0"
      "sha256-OyelTdU5Rwh1zsYfbRZ6t+pJNt4y3S96U2KJEqrIdsk=";

  mypy-boto3-mediatailor =
    buildMypyBoto3Package "mediatailor" "1.38.14"
      "sha256-mhgPrqIp5UdrI+zhEXjmYQbBjyeX8vuiWhwg8tSfo+w=";

  mypy-boto3-medical-imaging =
    buildMypyBoto3Package "medical-imaging" "1.38.0"
      "sha256-AsXfaApKIQnOom6wtqlcFQO1FdNAHWByzVA90drDYqY=";

  mypy-boto3-memorydb =
    buildMypyBoto3Package "memorydb" "1.38.0"
      "sha256-AA+ISIHdWSPd3RWx9QZlegfVFScBoSkm86R0leT+gzQ=";

  mypy-boto3-meteringmarketplace =
    buildMypyBoto3Package "meteringmarketplace" "1.38.0"
      "sha256-B+a+IwIkQX5DAvRpfBE0R+Gk5GLZnXg1pqOALELckXk=";

  mypy-boto3-mgh =
    buildMypyBoto3Package "mgh" "1.38.0"
      "sha256-QxbKPcQdbmkCP9SzxFnfoTJfKuGfne3JRbGEbNgFPdM=";

  mypy-boto3-mgn =
    buildMypyBoto3Package "mgn" "1.38.0"
      "sha256-mZ0b49W14rzoovXBEfn82/w5phMFTnNqQUmv6h+XtRY=";

  mypy-boto3-migration-hub-refactor-spaces =
    buildMypyBoto3Package "migration-hub-refactor-spaces" "1.38.0"
      "sha256-XhjuGE6t+Kz4gat+DBMP57VCCvYVfdH0LuyHLFtuGFc=";

  mypy-boto3-migrationhub-config =
    buildMypyBoto3Package "migrationhub-config" "1.38.0"
      "sha256-l4nK1KlPN68ol33fSSyI4Z1A8I/TPGAnnI9P9Zk13kk=";

  mypy-boto3-migrationhuborchestrator =
    buildMypyBoto3Package "migrationhuborchestrator" "1.38.0"
      "sha256-dwNQYU4Eq5UPOVw39A5WP8kLcsCtgWkrgtZ1DK9+hg0=";

  mypy-boto3-migrationhubstrategy =
    buildMypyBoto3Package "migrationhubstrategy" "1.38.0"
      "sha256-EsRpJAGOIoN02tmnPtccFZKp4+KNbpizantRQwFGVgg=";

  mypy-boto3-mq =
    buildMypyBoto3Package "mq" "1.38.0"
      "sha256-8dIVYQ+yjQchktht0HRdVkFLmKiWcEYUvwj2wZFlEwI=";

  mypy-boto3-mturk =
    buildMypyBoto3Package "mturk" "1.38.0"
      "sha256-wAV1UHqtLfNs+bh/PaWh61pT+wZU7cx3dfcjwxPR0m4=";

  mypy-boto3-mwaa =
    buildMypyBoto3Package "mwaa" "1.38.0"
      "sha256-2hV5TYKrrowbOqQZiw0DphDW2d2lFo8PYGolyqewznw=";

  mypy-boto3-neptune =
    buildMypyBoto3Package "neptune" "1.38.18"
      "sha256-5rStsb6FVG4I/4n3y4phDxUbfh9HTmOinaW/BQikp1Q=";

  mypy-boto3-neptunedata =
    buildMypyBoto3Package "neptunedata" "1.38.0"
      "sha256-U0fMJNyZpqwYlMuqTBSZCgAtls7IuyKnjWBAJ+6rTV8=";

  mypy-boto3-network-firewall =
    buildMypyBoto3Package "network-firewall" "1.38.25"
      "sha256-R2uEXo+0gtP1b76aKT9VWCKM0Uy3PulOO2T9WH2V8dM=";

  mypy-boto3-networkmanager =
    buildMypyBoto3Package "networkmanager" "1.38.0"
      "sha256-/vgg8tOKza+6g/CsvMA7A5wcSWk76bDvhLHjC+FWQr8=";

  mypy-boto3-nimble =
    buildMypyBoto3Package "nimble" "1.35.0"
      "sha256-gs9eGyRaZN7Fsl0D5fSqtTiYZ+Exp0s8QW/X8ZR7guA=";

  mypy-boto3-oam =
    buildMypyBoto3Package "oam" "1.38.20"
      "sha256-MM1WMowSubk22b/CG1OGxfozZ/svWVx4EpI5QHXPo1E=";

  mypy-boto3-omics =
    buildMypyBoto3Package "omics" "1.38.0"
      "sha256-kQpft2H5iVdqiGMabBv58F4DXLDKlxj904lVFW7SCcs=";

  mypy-boto3-opensearch =
    buildMypyBoto3Package "opensearch" "1.38.0"
      "sha256-t7kJRwLQt+QuAyeJpad0oogolyPMh3iVU6g3sGHeL1c=";

  mypy-boto3-opensearchserverless =
    buildMypyBoto3Package "opensearchserverless" "1.38.0"
      "sha256-7cXgZPuP3o5sM8VBjpOBawo5Nzi9OFwyinjHoz5scbE=";

  mypy-boto3-opsworks =
    buildMypyBoto3Package "opsworks" "1.38.0"
      "sha256-6jaLwgf7hDR1fMzjkiwcqhTb9yOWLcOi3cyrenmAxXE=";

  mypy-boto3-opsworkscm =
    buildMypyBoto3Package "opsworkscm" "1.38.0"
      "sha256-INwxXzcg6KDw6go1X0PPI3sjwgarFfullyoQfAzMlFQ=";

  mypy-boto3-organizations =
    buildMypyBoto3Package "organizations" "1.38.0"
      "sha256-D6SkcFfWhA4Xml+FHeu0QtggGdkSPuS1M8Y+4n5cHSU=";

  mypy-boto3-osis =
    buildMypyBoto3Package "osis" "1.38.0"
      "sha256-xZAOfmlN76G3Q0ZBbSgLBs7aAWjVNV9cWk/EFplSFTI=";

  mypy-boto3-outposts =
    buildMypyBoto3Package "outposts" "1.38.0"
      "sha256-Zohi64nwG4xQrEIOxeSVEo/r9zqL8Cg0Bg8Dnp0iJEY=";

  mypy-boto3-panorama =
    buildMypyBoto3Package "panorama" "1.38.0"
      "sha256-WUB4qt4LajzvKXQnhzYtWuFl+kWYUoJL2kj5qsNl9G4=";

  mypy-boto3-payment-cryptography =
    buildMypyBoto3Package "payment-cryptography" "1.38.0"
      "sha256-F3oKfxVR29NMNUgheG8i9WZhDyl+6mTSZEqDNzHCdQU=";

  mypy-boto3-payment-cryptography-data =
    buildMypyBoto3Package "payment-cryptography-data" "1.38.0"
      "sha256-XvULQjhXzn1bmjaESw1S6i2dXcYlppACL7S2ZyNne8E=";

  mypy-boto3-pca-connector-ad =
    buildMypyBoto3Package "pca-connector-ad" "1.38.0"
      "sha256-DQ0IVHT5qib96VNscf8sdA1esctaikssJYAuSizEEmg=";

  mypy-boto3-personalize =
    buildMypyBoto3Package "personalize" "1.38.0"
      "sha256-wKNO9BbmKUvLQcwbNgdpUVGGUaU2jvcvKdLJrIWfySw=";

  mypy-boto3-personalize-events =
    buildMypyBoto3Package "personalize-events" "1.38.0"
      "sha256-bhIsSyFBI0TSrZ1Pc0gbqio3Mf9N4/BEv146Eo+SvLI=";

  mypy-boto3-personalize-runtime =
    buildMypyBoto3Package "personalize-runtime" "1.38.0"
      "sha256-OCr0jmbNOCqL+g2L1HW6JdK2+DFPntmKQPr6XK+/yaI=";

  mypy-boto3-pi =
    buildMypyBoto3Package "pi" "1.38.0"
      "sha256-YOulV1nhU89gWf9M6ARo0l1K7pMDadTdZYJTEl/heBs=";

  mypy-boto3-pinpoint =
    buildMypyBoto3Package "pinpoint" "1.38.0"
      "sha256-ngtpdcngtRFMnEHoH/42IvNvmWmD+Y0gYDlZuKgN0K4=";

  mypy-boto3-pinpoint-email =
    buildMypyBoto3Package "pinpoint-email" "1.38.0"
      "sha256-blXjXeKjdoQvCyux7RjEtZT+LaK/Hs4PhEHnede3hOk=";

  mypy-boto3-pinpoint-sms-voice =
    buildMypyBoto3Package "pinpoint-sms-voice" "1.38.0"
      "sha256-WfamU2hFJm9m6PcGl4l+KFs5idOZf08rpgYUzZ+Z4vQ=";

  mypy-boto3-pinpoint-sms-voice-v2 =
    buildMypyBoto3Package "pinpoint-sms-voice-v2" "1.38.5"
      "sha256-VKOEb/ePb9Ra/+E538FVb4hUzqjoXBGfPoKV1ClugqQ=";

  mypy-boto3-pipes =
    buildMypyBoto3Package "pipes" "1.38.0"
      "sha256-q8MNFH9lbM6e+F98rBkPkmZUnAAm8Ex4ePQ6GRrlorg=";

  mypy-boto3-polly =
    buildMypyBoto3Package "polly" "1.38.0"
      "sha256-G7nQlatFX1liluz+6ZPhZZW0SPWDcllPcODHsZJTay8=";

  mypy-boto3-pricing =
    buildMypyBoto3Package "pricing" "1.38.0"
      "sha256-JNXmI8uVkxUdOzu1PvNhDEVh07EaLcv1tj227LPnkX0=";

  mypy-boto3-privatenetworks =
    buildMypyBoto3Package "privatenetworks" "1.38.0"
      "sha256-T04icQC+XwQZhaAEBWRiqfCUaayXP1szpbLdAG/7t3k=";

  mypy-boto3-proton =
    buildMypyBoto3Package "proton" "1.38.0"
      "sha256-2atVs2RwoZ97crB/mmjk9S1X23CClMHkJF/Q3/UmrSs=";

  mypy-boto3-qldb =
    buildMypyBoto3Package "qldb" "1.38.0"
      "sha256-H8fPe/MPZxP4cz/oneQaZK5DPROzJNcgmB64sNulTgs=";

  mypy-boto3-qldb-session =
    buildMypyBoto3Package "qldb-session" "1.38.0"
      "sha256-UKBld+nE46MZiJhlbY3tbiCxILSo/TEjhDW4z4jTdq0=";

  mypy-boto3-quicksight =
    buildMypyBoto3Package "quicksight" "1.38.0"
      "sha256-mQBTT6IX9mssBGnpCYqq2oKNHfjereOMRwVYsei2M4s=";

  mypy-boto3-ram =
    buildMypyBoto3Package "ram" "1.38.0"
      "sha256-pdJV8F0TUjXeNjd2oiGiCVoCU6MIFP8yi3DHyqFXBwE=";

  mypy-boto3-rbin =
    buildMypyBoto3Package "rbin" "1.38.0"
      "sha256-ZgecmO3dz66i2COSXzBjyUCtTkGGi9gnvb/HNNEq1AE=";

  mypy-boto3-rds =
    buildMypyBoto3Package "rds" "1.38.20"
      "sha256-xqpwwMxbxZlZ/sQ0IG+/ggA4a1g/8ffjchVOqkHrUuk=";

  mypy-boto3-rds-data =
    buildMypyBoto3Package "rds-data" "1.38.0"
      "sha256-SfdpEwO4k6hUOcXfx0TuF73OTKJeE5NjR4dyvBQWCLg=";

  mypy-boto3-redshift =
    buildMypyBoto3Package "redshift" "1.38.0"
      "sha256-NZgari0sOX1xG6GkI8IEKj1Y8aEA/RJS5SayoEGcSvw=";

  mypy-boto3-redshift-data =
    buildMypyBoto3Package "redshift-data" "1.38.0"
      "sha256-0mD9aI7KGbbjSatIn2kqN7cqN05mAr5FhIaXAi6JM2U=";

  mypy-boto3-redshift-serverless =
    buildMypyBoto3Package "redshift-serverless" "1.38.0"
      "sha256-Z4KREvXMPN874esEY9qY9dKfmscBtiON4EnU5fsuDxs=";

  mypy-boto3-rekognition =
    buildMypyBoto3Package "rekognition" "1.38.0"
      "sha256-AwopW1hKgKmC2ZXfEoUXg57FwWOkgSu2e2q20ukogc8=";

  mypy-boto3-resiliencehub =
    buildMypyBoto3Package "resiliencehub" "1.38.0"
      "sha256-xJSQ4m36XC98qB7wSgKcjIK4knHvf7pL47xxIiKInsc=";

  mypy-boto3-resource-explorer-2 =
    buildMypyBoto3Package "resource-explorer-2" "1.38.1"
      "sha256-TIahRC+cMQXpduzw6iQmBRXh/l7vDNsLAf0OlxDPSCU=";

  mypy-boto3-resource-groups =
    buildMypyBoto3Package "resource-groups" "1.38.0"
      "sha256-gwAooRklWfrnqsapzp8/citvHLScqD616HSOSLv65NM=";

  mypy-boto3-resourcegroupstaggingapi =
    buildMypyBoto3Package "resourcegroupstaggingapi" "1.38.0"
      "sha256-X8ddsKqSKjHX1NexWy/Xk7i1e57vndg39XX4R0Cv/64=";

  mypy-boto3-robomaker =
    buildMypyBoto3Package "robomaker" "1.38.0"
      "sha256-RAibNhwfXcELRkkERBoUd1r0EhOHBPiWWnntVQZTbvQ=";

  mypy-boto3-rolesanywhere =
    buildMypyBoto3Package "rolesanywhere" "1.38.0"
      "sha256-cIDEjQGl23GS6AY7A7+02z+XwMCrYoSYIWuYoBxKje8=";

  mypy-boto3-route53 =
    buildMypyBoto3Package "route53" "1.38.0"
      "sha256-10fMQviy733wJUI3O7E5m4WjJiThlSxiGPYd3o2kOl0=";

  mypy-boto3-route53-recovery-cluster =
    buildMypyBoto3Package "route53-recovery-cluster" "1.38.0"
      "sha256-yeDqUgeNjtj1TpEKO+1d4DKGPfL4p57UnCyPC43HG4s=";

  mypy-boto3-route53-recovery-control-config =
    buildMypyBoto3Package "route53-recovery-control-config" "1.38.0"
      "sha256-yTy8wqNi/UphsyWAIm4cShZCH2lXXmB1NOUlEMaj3fg=";

  mypy-boto3-route53-recovery-readiness =
    buildMypyBoto3Package "route53-recovery-readiness" "1.38.0"
      "sha256-RjGqKnY21mkIdDsou/xo4ejjrgnMpknfuO81eGM1jkw=";

  mypy-boto3-route53domains =
    buildMypyBoto3Package "route53domains" "1.38.0"
      "sha256-URJDdSfpwq2lfpdnf5U4CpQJpZTtpZswc0lODkb2Wfc=";

  mypy-boto3-route53resolver =
    buildMypyBoto3Package "route53resolver" "1.38.0"
      "sha256-DN8l+AbgvGY/VB8OufFoq+75u8iMWMIvnX80nfdwgT0=";

  mypy-boto3-rum =
    buildMypyBoto3Package "rum" "1.38.0"
      "sha256-gBkjxkSmaolRcBzYEbUwRvaZpEcPSD4cmfx/mi7VPM4=";

  mypy-boto3-s3 =
    buildMypyBoto3Package "s3" "1.38.0"
      "sha256-+P5YbkUSP/zTBaDDCEcSjzkx2IhknitMWlL0Ehg8hAo=";

  mypy-boto3-s3control =
    buildMypyBoto3Package "s3control" "1.38.14"
      "sha256-vCG6YvEf2ncO6cyqWW56LVXMh4dLzfz6uQAT50xzeuE=";

  mypy-boto3-s3outposts =
    buildMypyBoto3Package "s3outposts" "1.38.0"
      "sha256-lBWZesgIKYnjSjUOPBhF4GNsNSk09YDSEyX0qweT3iM=";

  mypy-boto3-sagemaker =
    buildMypyBoto3Package "sagemaker" "1.38.14"
      "sha256-XKVR3rpjs3qNWapIjo28h2D5CywnrBYi8dEbkCtzRhg=";

  mypy-boto3-sagemaker-a2i-runtime =
    buildMypyBoto3Package "sagemaker-a2i-runtime" "1.38.0"
      "sha256-hyl0sFcp6zFl4bq7q+G+ySG7ZG2ZrQ2rvbZxvjMmCH8=";

  mypy-boto3-sagemaker-edge =
    buildMypyBoto3Package "sagemaker-edge" "1.38.0"
      "sha256-ijtnBR2nHtJOq/mPRNzXWl6Rf5fyGbmGCvVNGbay8j0=";

  mypy-boto3-sagemaker-featurestore-runtime =
    buildMypyBoto3Package "sagemaker-featurestore-runtime" "1.38.0"
      "sha256-ohyBA4g++d87WtfDCOD/ZYFvpjhVyW69ctOe3qLJ8us=";

  mypy-boto3-sagemaker-geospatial =
    buildMypyBoto3Package "sagemaker-geospatial" "1.38.0"
      "sha256-2O4up2TlzIDE7EnR9ZTpHrjen9RkJfjdB2HTntQXJQ0=";

  mypy-boto3-sagemaker-metrics =
    buildMypyBoto3Package "sagemaker-metrics" "1.38.5"
      "sha256-l+F3dFMiNlh3VahRtl86EDx31xxvGXLVkd/ODXN/7A8=";

  mypy-boto3-sagemaker-runtime =
    buildMypyBoto3Package "sagemaker-runtime" "1.38.0"
      "sha256-fRN+4v4/ByTxazCXS1pgqr7lhXbsnQxkpF1RneX17yI=";

  mypy-boto3-savingsplans =
    buildMypyBoto3Package "savingsplans" "1.38.0"
      "sha256-7old3PAOBcxk+WTKU59Wr0RgqDTuaDWoi/DtBCf6TY0=";

  mypy-boto3-scheduler =
    buildMypyBoto3Package "scheduler" "1.38.0"
      "sha256-3uD6pOOy2Godau+D8UhwPdBGfXNsdL4zqS1/A513wzQ=";

  mypy-boto3-schemas =
    buildMypyBoto3Package "schemas" "1.38.0"
      "sha256-5Pn3/7XX5ExWQry45oc01tvH3AG95wfwKu0LI0i8DCI=";

  mypy-boto3-sdb =
    buildMypyBoto3Package "sdb" "1.38.0"
      "sha256-731cU951zthFJM0ZjTmUjf5KjBRiKqKLLe4qwLe+X4g=";

  mypy-boto3-secretsmanager =
    buildMypyBoto3Package "secretsmanager" "1.38.0"
      "sha256-FmYQjnDwPk3B3kSTiNf6y3erojGgJrrAwyQPwn/TGpg=";

  mypy-boto3-securityhub =
    buildMypyBoto3Package "securityhub" "1.38.0"
      "sha256-foCm+gCptN2lHLSXSB7OYyn/24Jx7cJ6SCxd4ItHzLg=";

  mypy-boto3-securitylake =
    buildMypyBoto3Package "securitylake" "1.38.0"
      "sha256-Z3lZTL6mDdqFYpCxau6KhhRVvj3V+aAd1t+ekzs5VLQ=";

  mypy-boto3-serverlessrepo =
    buildMypyBoto3Package "serverlessrepo" "1.38.0"
      "sha256-7oaAwnhk493zZlzZF6VL2rd2kWIw72ojUI7sEgwauTU=";

  mypy-boto3-service-quotas =
    buildMypyBoto3Package "service-quotas" "1.38.18"
      "sha256-93p1eVFFroBiRwpBWJMSa++CyP6/I9PaMFA8u4qHvvk=";

  mypy-boto3-servicecatalog =
    buildMypyBoto3Package "servicecatalog" "1.38.10"
      "sha256-usT75FXjlu2YAmgLrHVJWISnPmPXqgrl3aq3sPMamMk=";

  mypy-boto3-servicecatalog-appregistry =
    buildMypyBoto3Package "servicecatalog-appregistry" "1.38.0"
      "sha256-3YYgA865wTCleaRD2Am9H3CYQ0wrsT+RseOUhs678Rw=";

  mypy-boto3-servicediscovery =
    buildMypyBoto3Package "servicediscovery" "1.38.0"
      "sha256-2qsMBhQVTd5yzGhcX5mH4S9PgOeBXxE5/9wxcukXpMk=";

  mypy-boto3-ses =
    buildMypyBoto3Package "ses" "1.38.0"
      "sha256-F0Hjy6zoRUsSHZPSLUnII4vpVeudtgL2Vh1CIqbj3zA=";

  mypy-boto3-sesv2 =
    buildMypyBoto3Package "sesv2" "1.38.0"
      "sha256-ESw92+4DpLC7+72sHQb+kHGHx6htQ+CmSnd6DaLSzME=";

  mypy-boto3-shield =
    buildMypyBoto3Package "shield" "1.38.0"
      "sha256-I5wS2tRE9Fo9+gJKLgMP2gDA6BFqF+CsJ+1PCCm6R7U=";

  mypy-boto3-signer =
    buildMypyBoto3Package "signer" "1.38.0"
      "sha256-aIdfyQ3tVN3G+XqqF8fFHRJBpFnK2E0TUyLeWX/5+Qs=";

  mypy-boto3-simspaceweaver =
    buildMypyBoto3Package "simspaceweaver" "1.38.0"
      "sha256-minznoBq6k5/vRzDSOETy6/SelTZpm+V+aino+E1mhY=";

  mypy-boto3-sms =
    buildMypyBoto3Package "sms" "1.38.0"
      "sha256-cwswYTKcjKq/L6/nLYJ74OQ7pyZNeMxN1yHQWBpwT40=";

  mypy-boto3-sms-voice =
    buildMypyBoto3Package "sms-voice" "1.38.0"
      "sha256-qWnTJxM1h3pmY2PnI8PjT7u4+xODrSQM41IK8QsJCfM=";

  mypy-boto3-snow-device-management =
    buildMypyBoto3Package "snow-device-management" "1.38.0"
      "sha256-y+UNghmFC0O/SThTVVFM2/lVF0KOgYVZAvhBZHaI0AA=";

  mypy-boto3-snowball =
    buildMypyBoto3Package "snowball" "1.38.0"
      "sha256-zXeQTNSej3dBIUEAysAwjj1v94OZWBblb2AT/1a2oDI=";

  mypy-boto3-sns =
    buildMypyBoto3Package "sns" "1.38.0"
      "sha256-Dny+ycWR2w48WsvjrTxH37DljvlsE6rUnCfJ/eo9Rig=";

  mypy-boto3-sqs =
    buildMypyBoto3Package "sqs" "1.38.0"
      "sha256-Oa68Ehov4g+WL9g7YX/ZFgA2Bdb2hR/fGVM3oKpCj+E=";

  mypy-boto3-ssm =
    buildMypyBoto3Package "ssm" "1.38.5"
      "sha256-6Vu619L2tISbyUbrm7zB8TTL2q+xcsNlvt7NsxBO7g4=";

  mypy-boto3-ssm-contacts =
    buildMypyBoto3Package "ssm-contacts" "1.38.0"
      "sha256-Hf/2GGvvWjuGBLQk3Mj8fs0LxwnIAri7D1AF9siO4a8=";

  mypy-boto3-ssm-incidents =
    buildMypyBoto3Package "ssm-incidents" "1.38.0"
      "sha256-ZREA1Mafa4YcJGkXTZkcUuLsbE1bouK0lqk0zBA2RuM=";

  mypy-boto3-ssm-sap =
    buildMypyBoto3Package "ssm-sap" "1.38.0"
      "sha256-dZ8w8h6UgZpknc0lTMT1cNgG84uMmgQcptwxZ8d8z0Q=";

  mypy-boto3-sso =
    buildMypyBoto3Package "sso" "1.38.0"
      "sha256-qiG1fAHlB0AfSzdQXaLWpyQW9AB2BUfU/aUWW6NbKl8=";

  mypy-boto3-sso-admin =
    buildMypyBoto3Package "sso-admin" "1.38.12"
      "sha256-RU8IFZVVcJeO4lRa9DG87ue5YPhkqtJB6qjBKG4FZeo=";

  mypy-boto3-sso-oidc =
    buildMypyBoto3Package "sso-oidc" "1.38.0"
      "sha256-ogK5uKB+Y0nj/gTGPKoUV5BjDHlXLXyTwKq8Uvli0io=";

  mypy-boto3-stepfunctions =
    buildMypyBoto3Package "stepfunctions" "1.38.0"
      "sha256-sBAiZcSfoFN7210hRnfaiXN7eE9X7AI0DXIhBSgIipk=";

  mypy-boto3-storagegateway =
    buildMypyBoto3Package "storagegateway" "1.38.0"
      "sha256-sf4N+fCsuoJtLnpRzAj0Ze9H5szFig0d+1XbO8IoCpE=";

  mypy-boto3-sts =
    buildMypyBoto3Package "sts" "1.38.0"
      "sha256-FDqW8GvRfsS7sSDgS2XmRstDReLQ1MPFlviqBFjRJwc=";

  mypy-boto3-support =
    buildMypyBoto3Package "support" "1.38.0"
      "sha256-t68nmdYyH2z4C3F9jdn8zpwewF9r8oLYscbCEP6hq0A=";

  mypy-boto3-support-app =
    buildMypyBoto3Package "support-app" "1.38.0"
      "sha256-RNW2mz7JuCZiDHr8n1VG/rxbuwh+a9i8lhpw0dEFpEI=";

  mypy-boto3-swf =
    buildMypyBoto3Package "swf" "1.38.0"
      "sha256-b6TgvxWdQI5TAI/OsJzmzlte1v30NdJucdedKgCb9LY=";

  mypy-boto3-synthetics =
    buildMypyBoto3Package "synthetics" "1.38.25"
      "sha256-E9+a0LjuQfyxL/b/uZpMCrvWFmX2vPS+qJNMKcc10mU=";

  mypy-boto3-textract =
    buildMypyBoto3Package "textract" "1.38.0"
      "sha256-rfDZLT1heNBkjv4jrZSrhFV29TxEVfhOYmcZRzU4lx0=";

  mypy-boto3-timestream-query =
    buildMypyBoto3Package "timestream-query" "1.38.10"
      "sha256-FYUbGPt20ViawEF9UD3iY7US0JQcSavXV65vm4VvHwI=";

  mypy-boto3-timestream-write =
    buildMypyBoto3Package "timestream-write" "1.38.10"
      "sha256-Dbihs7mHeWkNzIMMgmxArM9OfWJM5FgDEc2VOMLaT9U=";

  mypy-boto3-tnb =
    buildMypyBoto3Package "tnb" "1.38.0"
      "sha256-X+cq+zQQnUm/8iusKqzkKzVUSFDvQYToiEwRb4rwSGc=";

  mypy-boto3-transcribe =
    buildMypyBoto3Package "transcribe" "1.38.0"
      "sha256-yfJCkmK3H/QJ0xApdUGfabwjgrHgu8r0mzKNDOsEDqk=";

  mypy-boto3-transfer =
    buildMypyBoto3Package "transfer" "1.38.0"
      "sha256-hOYOD8l0cDGKr3FNOSwMqGby64O6wmjHAL0F5hlOOK0=";

  mypy-boto3-translate =
    buildMypyBoto3Package "translate" "1.38.0"
      "sha256-ve7HllAv+PG6jHRZNp9Q32jpIEkCapOB4xZdpPYtZJQ=";

  mypy-boto3-verifiedpermissions =
    buildMypyBoto3Package "verifiedpermissions" "1.38.7"
      "sha256-fItaBlx3eeWHkKdYTSTeyUpTTeFc3cZdFaHBGVx7cLE=";

  mypy-boto3-voice-id =
    buildMypyBoto3Package "voice-id" "1.38.0"
      "sha256-14FLT6BCvEfFoS86fvtrbgu77Xz/doFjNtG+il5/o5w=";

  mypy-boto3-vpc-lattice =
    buildMypyBoto3Package "vpc-lattice" "1.38.0"
      "sha256-P23suQ3AHshp/XlqiCvi71/EzAdev8dweHx3PXkKFPo=";

  mypy-boto3-waf =
    buildMypyBoto3Package "waf" "1.38.0"
      "sha256-HyjR4eOXamDtFrC6+AkVT7M9Ecux693eB08k3unuixo=";

  mypy-boto3-waf-regional =
    buildMypyBoto3Package "waf-regional" "1.38.0"
      "sha256-ndTROc1T2APmQHL7EsSeU3XxWPYzp1e32tzqe4UDs/8=";

  mypy-boto3-wafv2 =
    buildMypyBoto3Package "wafv2" "1.38.0"
      "sha256-j50nk+lk4EaSjKHQ94ZWz0euxQSubBx3pTRSRObxBtc=";

  mypy-boto3-wellarchitected =
    buildMypyBoto3Package "wellarchitected" "1.38.0"
      "sha256-RzqZdCtCyIHbj8W6JSnqZs1+VX+LZzEH+quRqQsoQYw=";

  mypy-boto3-wisdom =
    buildMypyBoto3Package "wisdom" "1.38.0"
      "sha256-Sba0SVz57DTuHVLm1CN6GAscv3QpZry+QMM8iTHyED4=";

  mypy-boto3-workdocs =
    buildMypyBoto3Package "workdocs" "1.38.0"
      "sha256-ExsMz3dqZVd6qtr2khTqbaFpaMvJsaph63rh7/QCsJc=";

  mypy-boto3-worklink =
    buildMypyBoto3Package "worklink" "1.35.0"
      "sha256-AgK4Xg1dloJmA+h4+mcBQQVTvYKjLCk5tPDbl/ItCVQ=";

  mypy-boto3-workmail =
    buildMypyBoto3Package "workmail" "1.38.0"
      "sha256-ZP8DXd3ab28l3szBETpV22PNZ0oS83H1Ogs9Qpb8Yts=";

  mypy-boto3-workmailmessageflow =
    buildMypyBoto3Package "workmailmessageflow" "1.38.0"
      "sha256-naClNCiAqHalhT/+8cI510kBzYxpY3Z+wppDpQbZtdg=";

  mypy-boto3-workspaces =
    buildMypyBoto3Package "workspaces" "1.38.17"
      "sha256-vS6+uLpngMP/U2zM207LPzdzVl2DpB36/zyuM625r3o=";

  mypy-boto3-workspaces-web =
    buildMypyBoto3Package "workspaces-web" "1.38.0"
      "sha256-XF/GzodpRAVz5IZaP2tQPng34aXFvF0XwRqdzabMHIk=";

  mypy-boto3-xray =
    buildMypyBoto3Package "xray" "1.38.0"
      "sha256-E9rdQr458LPhOdPToAIcJOYX1n64sNCdrD19d5WzA4Q=";
}
