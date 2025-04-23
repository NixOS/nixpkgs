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
    buildMypyBoto3Package "acm" "1.38.0"
      "sha256-+ay1he8tFi3GdfDMPYbiY8KMWC6CXmPQRW56VHLze+s=";

  mypy-boto3-acm-pca =
    buildMypyBoto3Package "acm-pca" "1.38.0"
      "sha256-zp0Z4N8MRsKjQn7UaGC+MPkBT1mTP0wbJ0a5+p6A3/s=";

  mypy-boto3-amp =
    buildMypyBoto3Package "amp" "1.38.0"
      "sha256-nvTTdi/Mwtl8TE/CGonuuuFFd8b1tEPltEmO71KD5Cg=";

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
    buildMypyBoto3Package "appconfig" "1.38.0"
      "sha256-oyrJXkXHRvSRKGxS5MtSvhKqXWGJ+2gGJMDkIyObL+I=";

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
    buildMypyBoto3Package "application-autoscaling" "1.38.0"
      "sha256-lN2dqLobOiGThkSnm3W+2HRJfBYJNe9GyaI8sYA4cRk=";

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
    buildMypyBoto3Package "apprunner" "1.38.0"
      "sha256-tPT2wYmq50Swr65+CsmlpVM8xfuYmbJpauQahKC5ces=";

  mypy-boto3-appstream =
    buildMypyBoto3Package "appstream" "1.38.0"
      "sha256-0Ex+gq7lC3J1pxSpDZD6SJhxHnWosedNXMFMHdfG2Pc=";

  mypy-boto3-appsync =
    buildMypyBoto3Package "appsync" "1.38.0"
      "sha256-x6BAqHxN0Jc+TBhafSrNmtUy8GmKrJVrQsZSyqLbEkw=";

  mypy-boto3-arc-zonal-shift =
    buildMypyBoto3Package "arc-zonal-shift" "1.38.0"
      "sha256-ksKIbASQfKzf67Pkdv5HUipoep/8Qv7jVcjC4KCqAoI=";

  mypy-boto3-athena =
    buildMypyBoto3Package "athena" "1.38.0"
      "sha256-SiR/6d9mfd7nTd4aPtyknkBDhYTClMUkNLsNudW534o=";

  mypy-boto3-auditmanager =
    buildMypyBoto3Package "auditmanager" "1.38.0"
      "sha256-qJY3OmSAYR4/YEnayDfoSWElMQ0EKT++/JO+nBqf4A4=";

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
    buildMypyBoto3Package "ce" "1.38.0"
      "sha256-bdy/QUEmHR1czRK79z/vlayX3HGX0pzKQSQSg+eyTac=";

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
    buildMypyBoto3Package "cleanrooms" "1.38.0"
      "sha256-SfcrN5BVxW5t1zEUDUww6qOKqFrnu6DclVFwy8hWGVE=";

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
    buildMypyBoto3Package "cloudfront" "1.38.0"
      "sha256-KWreXmJoJNeEAZll8mBY5TsPS+M7y349CZJtki6eKuw=";

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
    buildMypyBoto3Package "cloudwatch" "1.38.0"
      "sha256-uzSSr2bpTrIDItc7eTBQ6lTxdCEYsY4255jk2v47Fn4=";

  mypy-boto3-codeartifact =
    buildMypyBoto3Package "codeartifact" "1.38.0"
      "sha256-II4WIgBsWK3+CXk/XFzWpmlEXsbBuWt4C3onExl2u0o=";

  mypy-boto3-codebuild =
    buildMypyBoto3Package "codebuild" "1.38.0"
      "sha256-MFSvGSyadm+jDU0a+zv5xIHlkhY1KCkfYSkRcbtBVsk=";

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
    buildMypyBoto3Package "codepipeline" "1.38.0"
      "sha256-xZ4+zTLVTEmfQ6nLwglF4pjeBqoz3dywPjhgBFr89ng=";

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
    buildMypyBoto3Package "cognito-idp" "1.38.0"
      "sha256-ytRI2TYHsl90U3QtD1k8QVhsd5ILcJB3YjWLIVf7qH8=";

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
    buildMypyBoto3Package "connect" "1.38.0"
      "sha256-S4dSNK7akvROloXwhPQJosJv/Ouizmkj/75Z/k8jlQ8=";

  mypy-boto3-connect-contact-lens =
    buildMypyBoto3Package "connect-contact-lens" "1.38.0"
      "sha256-IUoOWTLafI4fQhyvE5CoJPzTRp9o6NxMYSmyqqkzmno=";

  mypy-boto3-connectcampaigns =
    buildMypyBoto3Package "connectcampaigns" "1.38.0"
      "sha256-gHdrftxNKa7bI9AzBXKWKiwBQ5kK158LZx9peThWzGA=";

  mypy-boto3-connectcases =
    buildMypyBoto3Package "connectcases" "1.38.0"
      "sha256-7rqCgE1uNMy5hUg1+2xF4vivLjHm3gXjGy7BgiuraJw=";

  mypy-boto3-connectparticipant =
    buildMypyBoto3Package "connectparticipant" "1.38.0"
      "sha256-ABRIC59mat4ek0yrWxcHUr62whXmaZef47yDR7A2rl0=";

  mypy-boto3-controltower =
    buildMypyBoto3Package "controltower" "1.38.0"
      "sha256-3yIoiaPmgYBOTCYk2RQyHWyhUlA0qZXUfLnhKESeUWU=";

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
    buildMypyBoto3Package "datasync" "1.38.0"
      "sha256-Sk/XtOjc04Da6tfmbGg0feQah3mnsXDjXwKwCrLZ8ms=";

  mypy-boto3-dax =
    buildMypyBoto3Package "dax" "1.38.0"
      "sha256-uWL44n7FjT+BKuiJ2rbsg65x0kfxV4IdOAoLmrbeK5E=";

  mypy-boto3-detective =
    buildMypyBoto3Package "detective" "1.38.0"
      "sha256-vkRJVKcgvG0sZBoRAuHfSB3XiOAi5yNqLH0FRRjTRhg=";

  mypy-boto3-devicefarm =
    buildMypyBoto3Package "devicefarm" "1.38.0"
      "sha256-ym1xyz+EPxEK/U8/90CU107Y+cGqI90pgcLXU4GJdco=";

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
    buildMypyBoto3Package "dms" "1.38.0"
      "sha256-R1ZfmeNMPkkCg/O/nDR0Vqa7oNXlhxYOUG5jHW05NSo=";

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
    buildMypyBoto3Package "ds" "1.38.0"
      "sha256-GZGTzkx/DzyV2IxrAF/8VM+O0Pl4U+hXiXpbWCT+oho=";

  mypy-boto3-dynamodb =
    buildMypyBoto3Package "dynamodb" "1.38.0"
      "sha256-CSEHAyZp6hVaYAHDwNluJXauTP7Kj1RWbw7F4QNzQCg=";

  mypy-boto3-dynamodbstreams =
    buildMypyBoto3Package "dynamodbstreams" "1.38.0"
      "sha256-vUQbKxHwgpzzZVHVhkxs5F02qGajngs3OsxqBD3sGMA=";

  mypy-boto3-ebs =
    buildMypyBoto3Package "ebs" "1.38.0"
      "sha256-RQh46jrXqj4bXTRJ+tPR9sql7yUn7Ek9u4p0OU0A7b0=";

  mypy-boto3-ec2 =
    buildMypyBoto3Package "ec2" "1.38.0"
      "sha256-75De58jFMumZ5f04hEx1dLC8mdk+XdQWnO/eP4dfzKk=";

  mypy-boto3-ec2-instance-connect =
    buildMypyBoto3Package "ec2-instance-connect" "1.38.0"
      "sha256-1zg5Vw+V+bpp5FxTw0CSfxSN7JNVBwY4I8uDFhEJL3w=";

  mypy-boto3-ecr =
    buildMypyBoto3Package "ecr" "1.38.0"
      "sha256-JPXmkpdWjQSVG8Z7gH385dRy/3HUraLxDLdmO/mqZU4=";

  mypy-boto3-ecr-public =
    buildMypyBoto3Package "ecr-public" "1.38.0"
      "sha256-qJ22ZyzB+8OVRjRklxWYKJlA9WZg542CccUWmdx4p+s=";

  mypy-boto3-ecs =
    buildMypyBoto3Package "ecs" "1.38.0"
      "sha256-x1TKXNYuVv7hXpXPkjtdfre6pbfF0Hs3ih30yadVHzY=";

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
    buildMypyBoto3Package "emr" "1.38.0"
      "sha256-EG/qlpfpGaRJJhYPUACHM+TlHSwY+bYpgG5VxBAYTh0=";

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
    buildMypyBoto3Package "events" "1.38.0"
      "sha256-MBfgy4G5lVYXGzbs0aQK8qx3b16tmiAyq/ZTguwtbdI=";

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
    buildMypyBoto3Package "firehose" "1.38.0"
      "sha256-mmOpANvBTUTilWXZ8h5tMTwffEawd6HwVBJppLe1Z74=";

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
    buildMypyBoto3Package "glue" "1.38.0"
      "sha256-J6eSeVhhaNmtSqxvQ7w3F5EfVpGsliKn73AQSGo361k=";

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
    buildMypyBoto3Package "guardduty" "1.38.0"
      "sha256-2R+q3YsJFStb5pUj9LNPwZOZd3HqP54q5j1RhcJj3cA=";

  mypy-boto3-health =
    buildMypyBoto3Package "health" "1.38.0"
      "sha256-3LAT8F0uRrOVooWD6DdJaeYN9MRfOWEy7Ko19osn050=";

  mypy-boto3-healthlake =
    buildMypyBoto3Package "healthlake" "1.38.0"
      "sha256-z839V1DLHxIkZrSjzWpLbAMGszL3UokIHAHwaVFhSDQ=";

  mypy-boto3-iam =
    buildMypyBoto3Package "iam" "1.38.0"
      "sha256-Lh1EnEdDGQEWHNDQiDX5x08oF+TbzTd5IunMwYTqUs4=";

  mypy-boto3-identitystore =
    buildMypyBoto3Package "identitystore" "1.38.0"
      "sha256-n11mu3O2o2sPL13xPtwlWVvpNfVUdV7l7NO2lXg+ZyM=";

  mypy-boto3-imagebuilder =
    buildMypyBoto3Package "imagebuilder" "1.38.0"
      "sha256-DIO9k4N3y0WM/Em5io7lPeZ1USFDFPuS9/G/pEsuoGc=";

  mypy-boto3-importexport =
    buildMypyBoto3Package "importexport" "1.38.0"
      "sha256-1wv4Ld1ELjKflpwAEfpKY0bf9ktdrmeJuSo8MXr+PNM=";

  mypy-boto3-inspector =
    buildMypyBoto3Package "inspector" "1.38.0"
      "sha256-MaOetVmIqI8vVaVt6HCUXxrLO7lUm4i5DDzwfxEdLIg=";

  mypy-boto3-inspector2 =
    buildMypyBoto3Package "inspector2" "1.38.0"
      "sha256-swUv9KcYm0bsj11n5hRJayUXuFsLUZCQVrOQ+UaDJcE=";

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
    buildMypyBoto3Package "kinesis" "1.38.0"
      "sha256-UJi5o6gS/wNB3bl5MFWaZWzDGzZ44bvKkz3OQveAOZg=";

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
    buildMypyBoto3Package "license-manager" "1.38.0"
      "sha256-jDFm+V7sTX+oQeWt8aiW4yN2HeXz8fSu9ZjIn/vNoig=";

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
    buildMypyBoto3Package "logs" "1.38.0"
      "sha256-5jb6bzG4T2w9jNW4XYf9m6t2ZjGZnEoMg8LPAAPv5ac=";

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
    buildMypyBoto3Package "m2" "1.37.32"
      "sha256-qPc2mLV9druDbQCzQwQ36B5F8HjQ05rBEOo/bkRSxUU=";

  mypy-boto3-machinelearning =
    buildMypyBoto3Package "machinelearning" "1.37.0"
      "sha256-YTn8EOB9T+drHaHp6ET7Nh6HqPRnd2B5NMdy+HiZZxI=";

  mypy-boto3-macie2 =
    buildMypyBoto3Package "macie2" "1.37.0"
      "sha256-/nHhmdGNSHJ5/v1IL2wp62uWuwnusDbnkihjmvrv41s=";

  mypy-boto3-managedblockchain =
    buildMypyBoto3Package "managedblockchain" "1.37.0"
      "sha256-Dnm6sKxzxlWiiycoYhbkINspz4OqLRMxAn4BMScLwEA=";

  mypy-boto3-managedblockchain-query =
    buildMypyBoto3Package "managedblockchain-query" "1.37.0"
      "sha256-naqXWMUnk4wjL9Tb0D620BYqcOaKxIkkiGXObQZ7THY=";

  mypy-boto3-marketplace-catalog =
    buildMypyBoto3Package "marketplace-catalog" "1.37.0"
      "sha256-c8b/bdAfTYFJPJaK3q8+N5jQvV6/aMsoDbOxGY1OZL0=";

  mypy-boto3-marketplace-entitlement =
    buildMypyBoto3Package "marketplace-entitlement" "1.37.33"
      "sha256-7f81axpWfjpWpyxk+xdq1/apdUU3TI6M3SxUe4Aj3xo=";

  mypy-boto3-marketplacecommerceanalytics =
    buildMypyBoto3Package "marketplacecommerceanalytics" "1.37.0"
      "sha256-nh2m7H6RlfQlqmiifwYJ3SANi73zcju/v5s9z26HIvo=";

  mypy-boto3-mediaconnect =
    buildMypyBoto3Package "mediaconnect" "1.37.16"
      "sha256-TfeKy6dyjQJVyhmCjttwBxBQNi3iZdJQQwpY/HRvnf0=";

  mypy-boto3-mediaconvert =
    buildMypyBoto3Package "mediaconvert" "1.37.21"
      "sha256-Ltzv3h+NATTcKsyd1PfnUdjIhT3V0OS3woGsStyI/qA=";

  mypy-boto3-medialive =
    buildMypyBoto3Package "medialive" "1.37.32"
      "sha256-sCYbmByoD0ghBLx/ZFNdDdtXTdY3V5psSELPp6nhDH8=";

  mypy-boto3-mediapackage =
    buildMypyBoto3Package "mediapackage" "1.37.0"
      "sha256-tT+F001HVeqcZFaj7BEZw+NIZwekMRrNPo5oNR2OUhI=";

  mypy-boto3-mediapackage-vod =
    buildMypyBoto3Package "mediapackage-vod" "1.37.0"
      "sha256-c5KHSqJapAh71+VG8ZVltRXozAF4muW/p6d0g5EH7IQ=";

  mypy-boto3-mediapackagev2 =
    buildMypyBoto3Package "mediapackagev2" "1.37.12"
      "sha256-0rHFOkV7lFi6Q5cZV5b1jxYhSWTvL/mqb4cajRsCAeg=";

  mypy-boto3-mediastore =
    buildMypyBoto3Package "mediastore" "1.37.0"
      "sha256-gQwWhziTvb8qr6S2r8nvqszCqWKXCjrh50zblH8stQM=";

  mypy-boto3-mediastore-data =
    buildMypyBoto3Package "mediastore-data" "1.37.0"
      "sha256-g/KoroOmWZgWPfC0HMgLGQrGpr9QWEirTL3S9t7iMjs=";

  mypy-boto3-mediatailor =
    buildMypyBoto3Package "mediatailor" "1.37.38"
      "sha256-TobCXyGJhfpcRO8s6n6tl/gXxEHo4m8DXR5k1IkzWdw=";

  mypy-boto3-medical-imaging =
    buildMypyBoto3Package "medical-imaging" "1.37.0"
      "sha256-bySahvnK2ZFX2wETtu+PQyhbMYyH2RdcYMNEDnYMTzM=";

  mypy-boto3-memorydb =
    buildMypyBoto3Package "memorydb" "1.37.36"
      "sha256-9WLf5gu0g3GBaSumy9HaWQrG5w5z9v++SNxYbk+iyTk=";

  mypy-boto3-meteringmarketplace =
    buildMypyBoto3Package "meteringmarketplace" "1.37.33"
      "sha256-joIrlAK0NIC0HcBajFV28flaKX9P/7Fos2KrTBhrkVU=";

  mypy-boto3-mgh =
    buildMypyBoto3Package "mgh" "1.37.0"
      "sha256-a1U/zk4gLgbmNrlugN5ZRWHS8SfcKm7i8IxU5oLjq1A=";

  mypy-boto3-mgn =
    buildMypyBoto3Package "mgn" "1.37.0"
      "sha256-N0/6aVM9GgArp7A/XUQzDGE+ZDS6jvtsrqw3/kCU1Lo=";

  mypy-boto3-migration-hub-refactor-spaces =
    buildMypyBoto3Package "migration-hub-refactor-spaces" "1.37.0"
      "sha256-t176yLETg+7+0CLQ/4krTAbpbgsXX9VqL90d0Xx/2TU=";

  mypy-boto3-migrationhub-config =
    buildMypyBoto3Package "migrationhub-config" "1.37.0"
      "sha256-XRMvPnaqyHlPsZGsy/zkuccGnZGftvXHPyxCOa9ivJo=";

  mypy-boto3-migrationhuborchestrator =
    buildMypyBoto3Package "migrationhuborchestrator" "1.37.0"
      "sha256-zDIuMI/90Zwm0ViiRxnhyJc1Nz5dg4iUDbtq36ekmk4=";

  mypy-boto3-migrationhubstrategy =
    buildMypyBoto3Package "migrationhubstrategy" "1.37.0"
      "sha256-IqLHHwvWIsCvREzbPW/9k4APEuQFVfJD9Im7Q7mjYtY=";

  mypy-boto3-mq =
    buildMypyBoto3Package "mq" "1.37.0"
      "sha256-Veuj+t/PRiyErLFNqfl1R3UeQpvyaaNs1pfI0G9IaqI=";

  mypy-boto3-mturk =
    buildMypyBoto3Package "mturk" "1.37.0"
      "sha256-W0V+KIyfL551/RukX1HyzC8NiN9CtV/D9Fon3C7zdJU=";

  mypy-boto3-mwaa =
    buildMypyBoto3Package "mwaa" "1.37.0"
      "sha256-UVUivqrkG0oLLjMHw587VFVSolmpzaWdon8Xy2JKjis=";

  mypy-boto3-neptune =
    buildMypyBoto3Package "neptune" "1.37.0"
      "sha256-VrIQNJMCdsdvi1zRJpxS/FyVQ7Wafhjx+k+eOLiP5ew=";

  mypy-boto3-neptunedata =
    buildMypyBoto3Package "neptunedata" "1.37.0"
      "sha256-gA8+WKvFzCegzUUWvsTbEmHkYPLIomBrqaIRJHkJqhE=";

  mypy-boto3-network-firewall =
    buildMypyBoto3Package "network-firewall" "1.37.17"
      "sha256-Lth+Py9qwXU+mnbV21d9H7QoONrwWU1UmMCJWorypxs=";

  mypy-boto3-networkmanager =
    buildMypyBoto3Package "networkmanager" "1.37.23"
      "sha256-wJjK+WP4nS3CItgfxYXbo51y8SsZLRfe9nO5GanFiPg=";

  mypy-boto3-nimble =
    buildMypyBoto3Package "nimble" "1.35.0"
      "sha256-gs9eGyRaZN7Fsl0D5fSqtTiYZ+Exp0s8QW/X8ZR7guA=";

  mypy-boto3-oam =
    buildMypyBoto3Package "oam" "1.37.2"
      "sha256-XJE33wPIGIlSVxrJ3qE09AmFLkYwKR6zWXXtDnEVvSA=";

  mypy-boto3-omics =
    buildMypyBoto3Package "omics" "1.37.36"
      "sha256-sJXXQ3pKKNmXDplUe24dEboelzNpQe/Mkj+DNTjAg08=";

  mypy-boto3-opensearch =
    buildMypyBoto3Package "opensearch" "1.37.27"
      "sha256-I6WTuWXwC7c8LcRUTKn2VRNntm5DYmxnT8NEjha0LGA=";

  mypy-boto3-opensearchserverless =
    buildMypyBoto3Package "opensearchserverless" "1.37.0"
      "sha256-4uds4OY0uVk00x2eAjlKev/l80H4GjUMb6wagHDJwWI=";

  mypy-boto3-opsworks =
    buildMypyBoto3Package "opsworks" "1.37.0"
      "sha256-EA2UauZXjSQHrPSSqBnFwJXnsbtPIh16J8EMZ69BCRQ=";

  mypy-boto3-opsworkscm =
    buildMypyBoto3Package "opsworkscm" "1.37.0"
      "sha256-Z4FuwV4FciUtX9e0zTemuFMLh3UneBt6Rrw+0heF5fI=";

  mypy-boto3-organizations =
    buildMypyBoto3Package "organizations" "1.37.0"
      "sha256-4DWBTIGHw6kRAz5BSNO9IkQDe8h/6ymxJ8WaReoIOfY=";

  mypy-boto3-osis =
    buildMypyBoto3Package "osis" "1.37.0"
      "sha256-Pw/BAkTFGSJXFjERmhSCC+kA8+9oDkWUHXRbu1ntwyY=";

  mypy-boto3-outposts =
    buildMypyBoto3Package "outposts" "1.37.24"
      "sha256-Je+aFnbs4N1G9OMREy6A6RYJ/NRQ1LTI6GhmpnqAYzs=";

  mypy-boto3-panorama =
    buildMypyBoto3Package "panorama" "1.37.0"
      "sha256-5t43MNckv0+Gxdmp+4dkxMTtl9ToTk0Wfq9W0jr4Qko=";

  mypy-boto3-payment-cryptography =
    buildMypyBoto3Package "payment-cryptography" "1.37.23"
      "sha256-Uy3TNwYrc0j+a08H0POVX1GTPFdc/8KpVeCnm4rb9Zk=";

  mypy-boto3-payment-cryptography-data =
    buildMypyBoto3Package "payment-cryptography-data" "1.37.0"
      "sha256-+kdNkCBxY7tyNDgmZ9KNhkv4KB1kYr4A667AeRoY0XA=";

  mypy-boto3-pca-connector-ad =
    buildMypyBoto3Package "pca-connector-ad" "1.37.10"
      "sha256-e9sP379VsbZeKUhLURtsMsSPxfIvCsYVNqZhUg67+MY=";

  mypy-boto3-personalize =
    buildMypyBoto3Package "personalize" "1.37.29"
      "sha256-A7TLIG3TYVkSAAIRcn6OLoNSUpiwIEItwk4JI+f0nAc=";

  mypy-boto3-personalize-events =
    buildMypyBoto3Package "personalize-events" "1.37.0"
      "sha256-mClCFP70uTbiJFQcHQiJwwnlir7lNoonswr4/i2bgCM=";

  mypy-boto3-personalize-runtime =
    buildMypyBoto3Package "personalize-runtime" "1.37.0"
      "sha256-0Ha8v7Fo8R3mh3nBNmMaWcBT/FceLQiwxnL/1ZpepaQ=";

  mypy-boto3-pi =
    buildMypyBoto3Package "pi" "1.37.0"
      "sha256-34925z766jg4v+zt7pmh/SgUkYfz9g4eDx5jl7bviUc=";

  mypy-boto3-pinpoint =
    buildMypyBoto3Package "pinpoint" "1.37.0"
      "sha256-epGlYuJ1054KG89uzna+fxvhRYxF6ajDv2e3QoPBrGk=";

  mypy-boto3-pinpoint-email =
    buildMypyBoto3Package "pinpoint-email" "1.37.0"
      "sha256-w/oYhtW5+iYRpyFEPshdKn80dyLIicq5/HhvNP/Ne0g=";

  mypy-boto3-pinpoint-sms-voice =
    buildMypyBoto3Package "pinpoint-sms-voice" "1.37.0"
      "sha256-iZphmmci0zgWBSe7Q/7t+s1WpB8i5XABzVkwrxLuSvA=";

  mypy-boto3-pinpoint-sms-voice-v2 =
    buildMypyBoto3Package "pinpoint-sms-voice-v2" "1.37.0"
      "sha256-M0gmUpfwqZcZimW+hyAcWZ1MvQXlMhhLhO2RfttwRGM=";

  mypy-boto3-pipes =
    buildMypyBoto3Package "pipes" "1.37.0"
      "sha256-/Wr+oP8wfgSoeynyZDJ0fTS0T2oeBXR8DctO25S7qPU=";

  mypy-boto3-polly =
    buildMypyBoto3Package "polly" "1.37.21"
      "sha256-G9EVOO0mU8f/tAd/mg0/04lMkvs4+6JLHF3E+ylnyEo=";

  mypy-boto3-pricing =
    buildMypyBoto3Package "pricing" "1.37.4"
      "sha256-LGVcSjeM8AS69PVrUAqh+KaB94Fi1/KGbf2+kBPUu2s=";

  mypy-boto3-privatenetworks =
    buildMypyBoto3Package "privatenetworks" "1.37.0"
      "sha256-0rSXHg5NM16PebMnq4Cr5ToQcauOEbSzJzJQU1Oe0xM=";

  mypy-boto3-proton =
    buildMypyBoto3Package "proton" "1.37.0"
      "sha256-u+jh7zfrDUUXtFT2PjOlQSJh1Bv+xsaJekldwHn92Sw=";

  mypy-boto3-qldb =
    buildMypyBoto3Package "qldb" "1.37.0"
      "sha256-CE6/prrf6ZCoWTG5aPejO1Bz+FIFBeqYDS21UwMfmPM=";

  mypy-boto3-qldb-session =
    buildMypyBoto3Package "qldb-session" "1.37.0"
      "sha256-WqMrD+uGG7YQIQagu8L5pUOYMNHeneEQCYzkWrIZ+nA=";

  mypy-boto3-quicksight =
    buildMypyBoto3Package "quicksight" "1.37.32"
      "sha256-L5erTREMsMlqd/GlOxCY3V9Tj0sZa2m5gwXMmhOB3hs=";

  mypy-boto3-ram =
    buildMypyBoto3Package "ram" "1.37.0"
      "sha256-zHUGxicTW5aIZIh562Tvr6qQ1K0BSv+f38iCLh39d+I=";

  mypy-boto3-rbin =
    buildMypyBoto3Package "rbin" "1.37.0"
      "sha256-csr3DYjsomhq4T+97ZEQdjt0RfsXbo8kBFGrB6cUUmM=";

  mypy-boto3-rds =
    buildMypyBoto3Package "rds" "1.37.21"
      "sha256-j6eNB3ImSJ/vKNGzRJZGiCQl0ln5NSP3sIr9m3Yd/fg=";

  mypy-boto3-rds-data =
    buildMypyBoto3Package "rds-data" "1.37.0"
      "sha256-618WyrzlroxtyDGJi0ehIBQAYnGbd0JAfMLoVKlCFGc=";

  mypy-boto3-redshift =
    buildMypyBoto3Package "redshift" "1.37.0"
      "sha256-wG3bvzu38UyCF8n0J8gXnzzPMeJND22iRkjAbTADVNI=";

  mypy-boto3-redshift-data =
    buildMypyBoto3Package "redshift-data" "1.37.8"
      "sha256-A7lagOiAMhlsJqg7wQQm75l5dAUK22x3qK3P98r4gbg=";

  mypy-boto3-redshift-serverless =
    buildMypyBoto3Package "redshift-serverless" "1.37.3"
      "sha256-EAlTSaiF3t6eOMP/hlDTtqI0l3uX6oLOMZ7Ij+Qs/20=";

  mypy-boto3-rekognition =
    buildMypyBoto3Package "rekognition" "1.37.0"
      "sha256-ozwlq5US07sA2HMoOvtyo1/d1O8ixsMFqthTwo3BWjw=";

  mypy-boto3-resiliencehub =
    buildMypyBoto3Package "resiliencehub" "1.37.0"
      "sha256-wLY1vGfvF5yWbCY88AVzLZ2bJlpuGAn4F+H+G0DezBQ=";

  mypy-boto3-resource-explorer-2 =
    buildMypyBoto3Package "resource-explorer-2" "1.37.0"
      "sha256-031skcPZd/jBWIod9JAbIc9NUcEBBN33UxIoGc2IiAA=";

  mypy-boto3-resource-groups =
    buildMypyBoto3Package "resource-groups" "1.37.35"
      "sha256-ae1MUUGAapRCLaWrMzlzQvNc+9ijTQxFMlxqvOFD4WI=";

  mypy-boto3-resourcegroupstaggingapi =
    buildMypyBoto3Package "resourcegroupstaggingapi" "1.37.0"
      "sha256-JZErRwxR1RB5l3JhHByOWjtXdzaJEkYQZE9wgGkC9ZQ=";

  mypy-boto3-robomaker =
    buildMypyBoto3Package "robomaker" "1.37.0"
      "sha256-u4MVTUt8qW9Vmr8+qDMke5gukzriEAxPb1pbG+HaJAI=";

  mypy-boto3-rolesanywhere =
    buildMypyBoto3Package "rolesanywhere" "1.37.0"
      "sha256-axaTu4XmHGc3a/Uzs1/0IqLJdZFBfEQ9pzi42XW11y0=";

  mypy-boto3-route53 =
    buildMypyBoto3Package "route53" "1.37.27"
      "sha256-9K+1O7X5Ey2xED7rFT5Qfv8XGAxzGYIdf2SGqb95KqE=";

  mypy-boto3-route53-recovery-cluster =
    buildMypyBoto3Package "route53-recovery-cluster" "1.37.0"
      "sha256-0hUuTUVv6+WqpPn+TJVgsl5bIuw0WejLarVu/hv1trk=";

  mypy-boto3-route53-recovery-control-config =
    buildMypyBoto3Package "route53-recovery-control-config" "1.37.18"
      "sha256-biOC1fq0Fduxbh07i/LZWTeX+FPvWmrU7asljtW3fKg=";

  mypy-boto3-route53-recovery-readiness =
    buildMypyBoto3Package "route53-recovery-readiness" "1.37.0"
      "sha256-BLrTyePwfPIYM3eRRBncGPGWOjnIRw9TpvYXwAD42Vk=";

  mypy-boto3-route53domains =
    buildMypyBoto3Package "route53domains" "1.37.0"
      "sha256-m7jX2Z+PVIS70S+LD7eCYWqLiSSyReKv4z+/fpZ3HPo=";

  mypy-boto3-route53resolver =
    buildMypyBoto3Package "route53resolver" "1.37.0"
      "sha256-/4XdwWIkx8VYxrUp7I8IDCPZ34cFudV+gp3xR4uS8jk=";

  mypy-boto3-rum =
    buildMypyBoto3Package "rum" "1.37.14"
      "sha256-bcK4J78YctKUypiegFviiZ2TorcXA5SPh9dhbRigVhk=";

  mypy-boto3-s3 =
    buildMypyBoto3Package "s3" "1.37.24"
      "sha256-TfCXUlYTKrRSiWudNlcYZqgWFX1RnPEsZheVspBuLpw=";

  mypy-boto3-s3control =
    buildMypyBoto3Package "s3control" "1.37.28"
      "sha256-x7tDVAto4sE6VcosLjnf81rxLuyDkqIT93mbGTM3zdU=";

  mypy-boto3-s3outposts =
    buildMypyBoto3Package "s3outposts" "1.37.0"
      "sha256-c0vXkW5sR7JkdzvsS/rMFme9EwY1x5eZAbRWYKew0v4=";

  mypy-boto3-sagemaker =
    buildMypyBoto3Package "sagemaker" "1.37.37"
      "sha256-wzoSSsiKVLf1Vk5v87Fz7HEpsppnOHXCGWnqabz6W2k=";

  mypy-boto3-sagemaker-a2i-runtime =
    buildMypyBoto3Package "sagemaker-a2i-runtime" "1.37.0"
      "sha256-+QJSB+rrGosPxi/O9rRp/fZ0sLh+/a3dDTA8ef1xyck=";

  mypy-boto3-sagemaker-edge =
    buildMypyBoto3Package "sagemaker-edge" "1.37.0"
      "sha256-ZbzXY/4h5g8+l8knUnayduHLsJhlBf69hufbiCHNZp0=";

  mypy-boto3-sagemaker-featurestore-runtime =
    buildMypyBoto3Package "sagemaker-featurestore-runtime" "1.37.0"
      "sha256-mVYTPGFLZM0zMhbsJv7pej8z1aRhGOoaKZB78g+XXS0=";

  mypy-boto3-sagemaker-geospatial =
    buildMypyBoto3Package "sagemaker-geospatial" "1.37.0"
      "sha256-lucySLBSMrg5ENzWKW9EkEzZgZYEMq7BNKmaVDlZAVI=";

  mypy-boto3-sagemaker-metrics =
    buildMypyBoto3Package "sagemaker-metrics" "1.37.0"
      "sha256-LrjiQaAlhkTpW/Tsk76u4gFH66WBDb6tmMh+8oI49k0=";

  mypy-boto3-sagemaker-runtime =
    buildMypyBoto3Package "sagemaker-runtime" "1.37.0"
      "sha256-FQPurpofExwMTW4wmEX5DAg8jq24D4CtRESHaBXv1Hc=";

  mypy-boto3-savingsplans =
    buildMypyBoto3Package "savingsplans" "1.37.0"
      "sha256-7cWfa4r+1vVvZ5Z1OorZNlLIllaF44RSuuyW/A3CxxA=";

  mypy-boto3-scheduler =
    buildMypyBoto3Package "scheduler" "1.37.0"
      "sha256-XU/tZnffFHZRe0aVlN43v3vApOZHmw0+w0mHuUWP0MA=";

  mypy-boto3-schemas =
    buildMypyBoto3Package "schemas" "1.37.0"
      "sha256-GncOqi7qFYlBAoM0rz0J7kp+tcc+8a7A8wl9D9EOHMg=";

  mypy-boto3-sdb =
    buildMypyBoto3Package "sdb" "1.37.0"
      "sha256-Bkqp6Z+FWf0DI79bGraZai5iMC5eygvumStvLh+unQw=";

  mypy-boto3-secretsmanager =
    buildMypyBoto3Package "secretsmanager" "1.37.0"
      "sha256-BpQNhC56YA/fVCGQ4rD9Ncp5FMsRi1pXgDa6bOZZpBs=";

  mypy-boto3-securityhub =
    buildMypyBoto3Package "securityhub" "1.37.30"
      "sha256-I3QYmSWmdS2/ncxkXzOaXYoM59txDx1vDPbbN31ic00=";

  mypy-boto3-securitylake =
    buildMypyBoto3Package "securitylake" "1.37.0"
      "sha256-gcUVxwZaXBgpRFZNhUTDTmdJyQFf+dXEHDMSywBFaI4=";

  mypy-boto3-serverlessrepo =
    buildMypyBoto3Package "serverlessrepo" "1.37.0"
      "sha256-p8UzqjJKotp078KSppX0SidBrCOfGY1/AocYHO5xVmc=";

  mypy-boto3-service-quotas =
    buildMypyBoto3Package "service-quotas" "1.37.37"
      "sha256-34/LgfRPto8cRGKpxf6Xc43jD0BE4VMFTw5FeJfRV3c=";

  mypy-boto3-servicecatalog =
    buildMypyBoto3Package "servicecatalog" "1.37.35"
      "sha256-blNOCdn3J1XNwGjWMo5eN+a2SzKqCt/1at8l8AzNZsg=";

  mypy-boto3-servicecatalog-appregistry =
    buildMypyBoto3Package "servicecatalog-appregistry" "1.37.0"
      "sha256-b9SB3hFPtlFGh6MdyqPBmY7L1JrjGfmIjMADRaRulDo=";

  mypy-boto3-servicediscovery =
    buildMypyBoto3Package "servicediscovery" "1.37.0"
      "sha256-ISQRpYx0Sc6dhlg6T9ofGfX6H0P2L3QdIzWYVkvwA7I=";

  mypy-boto3-ses =
    buildMypyBoto3Package "ses" "1.37.0"
      "sha256-hD2HVQKPSoNJ/t8VVOkaz+kVV3bF9DXLvYh6vG15GvM=";

  mypy-boto3-sesv2 =
    buildMypyBoto3Package "sesv2" "1.37.27"
      "sha256-rJ0eb2xRnLf0LO1DW7L955QcCBdE3LtWjsvDUN+HFi8=";

  mypy-boto3-shield =
    buildMypyBoto3Package "shield" "1.37.0"
      "sha256-mhzk3KDgjFkldsaFQEHTNW/eOCOnpXkHCcyeBkraZSU=";

  mypy-boto3-signer =
    buildMypyBoto3Package "signer" "1.37.0"
      "sha256-SXv8A4Q3vFUXZ/gv8fQ0+HbvVRdClyBVt4x/bDUv4ns=";

  mypy-boto3-simspaceweaver =
    buildMypyBoto3Package "simspaceweaver" "1.37.0"
      "sha256-XBBF9usRMGeQhfDttw11yGfDGituZsfR1AZsn9jiI+4=";

  mypy-boto3-sms =
    buildMypyBoto3Package "sms" "1.37.0"
      "sha256-gZw4C1ZQyItwrb/FSvi0ceLETMO+hkC5pAqt0s3c/fg=";

  mypy-boto3-sms-voice =
    buildMypyBoto3Package "sms-voice" "1.37.0"
      "sha256-BOr9Z7pTzVV25ihSAlHdvYR8y6AGDGe9WvbNetJER5M=";

  mypy-boto3-snow-device-management =
    buildMypyBoto3Package "snow-device-management" "1.37.0"
      "sha256-/gDAwLMWfdWhmDyWFHUaru94Wy1J/sgWYkgrujMM2z4=";

  mypy-boto3-snowball =
    buildMypyBoto3Package "snowball" "1.37.0"
      "sha256-FMyrkG+kWQZMN2zL2SA/QWQQ8UMUesdfCUQHupl61oA=";

  mypy-boto3-sns =
    buildMypyBoto3Package "sns" "1.37.0"
      "sha256-1VrtUyV443XdmOKZoxUnBAb+ezSs53JRvQdHd9aKR4g=";

  mypy-boto3-sqs =
    buildMypyBoto3Package "sqs" "1.37.0"
      "sha256-7VbfcklEJdTn0OBI8jIcwXUU+ju+38QQu7i3CcS/9WQ=";

  mypy-boto3-ssm =
    buildMypyBoto3Package "ssm" "1.37.19"
      "sha256-bopkgSzOq7haz6di3A/v4GVJfSJ0oJU266uxygLPhfk=";

  mypy-boto3-ssm-contacts =
    buildMypyBoto3Package "ssm-contacts" "1.37.0"
      "sha256-4YzyVZ8GOBBRnk0NATeMpX1LSUNH4h0PxUnSJqfGXOQ=";

  mypy-boto3-ssm-incidents =
    buildMypyBoto3Package "ssm-incidents" "1.37.0"
      "sha256-P+EAtNV7KBHpqZLOvuFFonPnSL+DDqUc28yeOItbfQk=";

  mypy-boto3-ssm-sap =
    buildMypyBoto3Package "ssm-sap" "1.37.0"
      "sha256-RAyyemwp05G1VPwlA/zc7Jv2OrWFiTTRy9d65lgUV9I=";

  mypy-boto3-sso =
    buildMypyBoto3Package "sso" "1.37.0"
      "sha256-a0607aluZZpy4QctAo+TtJWguDSi+1gQWPqday1TC20=";

  mypy-boto3-sso-admin =
    buildMypyBoto3Package "sso-admin" "1.37.0"
      "sha256-y4IyBLiayIZObpAK/to12GaqhDqiKnJDta+038BdNSg=";

  mypy-boto3-sso-oidc =
    buildMypyBoto3Package "sso-oidc" "1.37.22"
      "sha256-ahiaClNbudP2banQ8+HK8BYkQARVo5dW9W9W7/LmkpY=";

  mypy-boto3-stepfunctions =
    buildMypyBoto3Package "stepfunctions" "1.37.0"
      "sha256-TI4+rVDXiOqI1viEFwbSlvDbwzdKPbTne4pZsdK9HRo=";

  mypy-boto3-storagegateway =
    buildMypyBoto3Package "storagegateway" "1.37.30"
      "sha256-MO27+ha1NA6hHenR5tz18SQZLlj/xRN0PRh3PoPMtrw=";

  mypy-boto3-sts =
    buildMypyBoto3Package "sts" "1.37.0"
      "sha256-SnXlBwReZAM7px6zEif1iY+nRFsnnrWNRf2SDZW+yqA=";

  mypy-boto3-support =
    buildMypyBoto3Package "support" "1.37.0"
      "sha256-JBCoU6G8j0afes9TuOKzCjuAlfmFcF7k3930d7b9YGE=";

  mypy-boto3-support-app =
    buildMypyBoto3Package "support-app" "1.37.0"
      "sha256-tjKFOee35M0taBAcBPi/3xPM+4Uqgq7K0r127gFWTjw=";

  mypy-boto3-swf =
    buildMypyBoto3Package "swf" "1.37.0"
      "sha256-6aDSreVPoJW6fvjsblI/FhvKNvJEd6x6cstfiD+6TzY=";

  mypy-boto3-synthetics =
    buildMypyBoto3Package "synthetics" "1.37.0"
      "sha256-Q6jp3mno2bHBHEDvPBrJwgBpEm+ImlFJHIBvKyP+b38=";

  mypy-boto3-textract =
    buildMypyBoto3Package "textract" "1.37.0"
      "sha256-i1CDDf10g0E5aU1j0fTuBLtdSnlCZ+bijDIjv5sw6Jc=";

  mypy-boto3-timestream-query =
    buildMypyBoto3Package "timestream-query" "1.37.0"
      "sha256-aQHdWjauDHjUI37N8Nif29qWZzRhbSonUYL9ZxKTiVI=";

  mypy-boto3-timestream-write =
    buildMypyBoto3Package "timestream-write" "1.37.0"
      "sha256-XKJCht/z7eHSjhbPLXPbB5DnGmCdMfuDjEhZTIzE6gg=";

  mypy-boto3-tnb =
    buildMypyBoto3Package "tnb" "1.37.0"
      "sha256-mGqJUJF826MADOYCDXwPNbk+x82zumHRb+cTazCEzAY=";

  mypy-boto3-transcribe =
    buildMypyBoto3Package "transcribe" "1.37.27"
      "sha256-UW0b40n+M8za5guDPxhU5cRvtbkqzX6G7M2UaxNq5ws=";

  mypy-boto3-transfer =
    buildMypyBoto3Package "transfer" "1.37.31"
      "sha256-2YiHVXvLrc72mi78aUHkQ5zkD747y9DvNbXUFewJaro=";

  mypy-boto3-translate =
    buildMypyBoto3Package "translate" "1.37.0"
      "sha256-zFNm+yUojgowwXWi604nKqOkguMDHyarvf3ee1dFHj8=";

  mypy-boto3-verifiedpermissions =
    buildMypyBoto3Package "verifiedpermissions" "1.37.33"
      "sha256-SWFRxu10Wjlq5uT7hsDRN8V5n7+FuMH6dk2R7np96uw=";

  mypy-boto3-voice-id =
    buildMypyBoto3Package "voice-id" "1.37.0"
      "sha256-FYvcpTWB/yBcEJkcYLIIAOLIxrnPU4x7bnhgxktYgw4=";

  mypy-boto3-vpc-lattice =
    buildMypyBoto3Package "vpc-lattice" "1.37.0"
      "sha256-MD0cDJFNwAaqF65SUTeQBFaSfk/sUaL8owRKJGxtG10=";

  mypy-boto3-waf =
    buildMypyBoto3Package "waf" "1.37.0"
      "sha256-OWi6mpOe/tsX6e4mL5PldT7WNNdCk8VpmKJYhOUwgpk=";

  mypy-boto3-waf-regional =
    buildMypyBoto3Package "waf-regional" "1.37.0"
      "sha256-nBigZ8YNNcy6TrQQ+dThN62xZ5IOq92EHbC3/tZbbuE=";

  mypy-boto3-wafv2 =
    buildMypyBoto3Package "wafv2" "1.37.21"
      "sha256-EiksZIqxgX/H/YF7Yo0B2YIQzgIYqcFhol81jDL9gKk=";

  mypy-boto3-wellarchitected =
    buildMypyBoto3Package "wellarchitected" "1.37.0"
      "sha256-eO6jC+Ypn01Im6GXo7KufnzDe1ZzASdU5fE1dPJ9KjQ=";

  mypy-boto3-wisdom =
    buildMypyBoto3Package "wisdom" "1.37.0"
      "sha256-zCSw+g6/g5GANZTLTrse93B3kNRGNfIfIANLZmHnz1U=";

  mypy-boto3-workdocs =
    buildMypyBoto3Package "workdocs" "1.37.0"
      "sha256-6JxX7gw1YZAQZcAbW/4r+kpWD89yePlu+AS8rgyUx7Y=";

  mypy-boto3-worklink =
    buildMypyBoto3Package "worklink" "1.35.0"
      "sha256-AgK4Xg1dloJmA+h4+mcBQQVTvYKjLCk5tPDbl/ItCVQ=";

  mypy-boto3-workmail =
    buildMypyBoto3Package "workmail" "1.37.0"
      "sha256-BY9wsXmWOV9PM4Ba+jyQCx6wr3vQEnHVGWLGnDjRzyE=";

  mypy-boto3-workmailmessageflow =
    buildMypyBoto3Package "workmailmessageflow" "1.37.0"
      "sha256-s/XZZvav3P9Fr6vyBII7NubWRChEg4HASNzN4UypcPo=";

  mypy-boto3-workspaces =
    buildMypyBoto3Package "workspaces" "1.37.8"
      "sha256-90SHx94sQuuHlnshgsO9WeTOj/l9eVerDmz1Wf584/o=";

  mypy-boto3-workspaces-web =
    buildMypyBoto3Package "workspaces-web" "1.37.0"
      "sha256-+s+4AUrgkXzEbgY2gYIBJGKBZxkOLFbFD6JdUfayPBA=";

  mypy-boto3-xray =
    buildMypyBoto3Package "xray" "1.37.0"
      "sha256-nJhGLgVx7bYXpX5iizDXyyGOSUCF0qf3JcsV6NNHrXw=";
}
