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
    buildMypyBoto3Package "directconnect" "1.37.21"
      "sha256-G1oWu51jsk80Y2CHCg+Wj/LrU+BN1Z0urmuHjWi+kp4=";

  mypy-boto3-discovery =
    buildMypyBoto3Package "discovery" "1.37.0"
      "sha256-AK4bOVdDkLDhhJPKmXLEbgEDw4X7mUA6ZRPFctNumE8=";

  mypy-boto3-dlm =
    buildMypyBoto3Package "dlm" "1.37.0"
      "sha256-XUl7lWJvL6safxXCh1bLWz6SJbSqoY0gzLkrhm2rgJc=";

  mypy-boto3-dms =
    buildMypyBoto3Package "dms" "1.37.4"
      "sha256-GQxq0/FfkLrojbsPpkrmgHmg0B4v0Jj5sluZoeyQqGg=";

  mypy-boto3-docdb =
    buildMypyBoto3Package "docdb" "1.37.0"
      "sha256-dq8LrgsWS7q5GHypTdDUyD2V/qXNkhI6IhMKoo1wqps=";

  mypy-boto3-docdb-elastic =
    buildMypyBoto3Package "docdb-elastic" "1.37.0"
      "sha256-VezOut+20Njj3hHaKyMmks8f+/Jmv10aUOcjDmlHfKc=";

  mypy-boto3-drs =
    buildMypyBoto3Package "drs" "1.37.0"
      "sha256-xeRuUCpBlkdbVKBqEsAJf93Bs1t5XpuhFynerqSwT/c=";

  mypy-boto3-ds =
    buildMypyBoto3Package "ds" "1.37.0"
      "sha256-Ip3JFGZnN112dRHwGbtx/Qu9lIhBkbeB5dTIJ3TJFEo=";

  mypy-boto3-dynamodb =
    buildMypyBoto3Package "dynamodb" "1.37.33"
      "sha256-+SSZnUX8I90ICzC00QSYYnIgv40/R4JKUT5DRFueoC0=";

  mypy-boto3-dynamodbstreams =
    buildMypyBoto3Package "dynamodbstreams" "1.37.0"
      "sha256-pw1aeeDPy05KNtDQIukOtDScxvkI6AQgZSqCQpdzFKY=";

  mypy-boto3-ebs =
    buildMypyBoto3Package "ebs" "1.37.0"
      "sha256-wvOqjmqNMbCG7E1o+ZSOlWEwBdcCKjD/qVFlepZ51ec=";

  mypy-boto3-ec2 =
    buildMypyBoto3Package "ec2" "1.37.28"
      "sha256-dx0gBM/f+dTcfPbkkD/pB8MnAHpNcE4AmjseawCunfQ=";

  mypy-boto3-ec2-instance-connect =
    buildMypyBoto3Package "ec2-instance-connect" "1.37.0"
      "sha256-Sqer8nDDdeGo8/ZEi7Cv7duJ2OQB0uEBOAY9CsaKDqI=";

  mypy-boto3-ecr =
    buildMypyBoto3Package "ecr" "1.37.26"
      "sha256-jRNm95G1n9V0y2gEHhxrPiUbZHhTiSHTdvkW05viLqs=";

  mypy-boto3-ecr-public =
    buildMypyBoto3Package "ecr-public" "1.37.0"
      "sha256-7Sz4g1+0B99ZybhrzJOS0K71thybaDPUYmF4+SN1sGc=";

  mypy-boto3-ecs =
    buildMypyBoto3Package "ecs" "1.37.36"
      "sha256-9bjyK1uqd81ecObI8jPW5hooS/07pqTdiVFcBzMQvTs=";

  mypy-boto3-efs =
    buildMypyBoto3Package "efs" "1.37.0"
      "sha256-uKccWDS0zhFrs6CQ9ve6by4rYL43T6iFZ3rjNy7SiyI=";

  mypy-boto3-eks =
    buildMypyBoto3Package "eks" "1.37.35"
      "sha256-Uk7r11ayOnQl6HSiFHlfpj7whRFjSz8nJMxxs0ZZn/w=";

  mypy-boto3-elastic-inference =
    buildMypyBoto3Package "elastic-inference" "1.36.0"
      "sha256-duU3LIeW3FNiplVmduZsNXBoDK7vbO6ecrBt1Y7C9rU=";

  mypy-boto3-elasticache =
    buildMypyBoto3Package "elasticache" "1.37.32"
      "sha256-AU4VlQI9zibzYltSjoHsmA5d6yWNsdPBT5NbFNXqQDg=";

  mypy-boto3-elasticbeanstalk =
    buildMypyBoto3Package "elasticbeanstalk" "1.37.0"
      "sha256-LFL4/kd3QdyNo2JMQiJYyrsW1nUfMJ9/LWVDE8qx+wA=";

  mypy-boto3-elastictranscoder =
    buildMypyBoto3Package "elastictranscoder" "1.37.0"
      "sha256-h1hUoDGwVC3shOU236Z7GvphwsFnm+6lVMVYz7hjadM=";

  mypy-boto3-elb =
    buildMypyBoto3Package "elb" "1.37.0"
      "sha256-2loxTqxOQxGiJkuLh7qgIaGSuML0/xN3f3AKHQoMT+Q=";

  mypy-boto3-elbv2 =
    buildMypyBoto3Package "elbv2" "1.37.9"
      "sha256-5on02YhbX9VXGjAhgjrBv8MnxouLEO5CJrcNCtBpfo8=";

  mypy-boto3-emr =
    buildMypyBoto3Package "emr" "1.37.3"
      "sha256-sU9kfLIwN/wR6/xu3YI70jXgAg85Mf7/rL5G7xxmsKs=";

  mypy-boto3-emr-containers =
    buildMypyBoto3Package "emr-containers" "1.37.0"
      "sha256-qBDRNmLpGei/Vwdl6FViIL6qLphVQfJwBpDvauDP1Ns=";

  mypy-boto3-emr-serverless =
    buildMypyBoto3Package "emr-serverless" "1.37.0"
      "sha256-lDjdGwuVL4nHr15/bsRltt0AGqvMznirSTX8aiQY/fE=";

  mypy-boto3-entityresolution =
    buildMypyBoto3Package "entityresolution" "1.37.34"
      "sha256-XPUK//bAuyhoJSnJpRQcTB6rxU1Dt2b4sVxMIkfpCGc=";

  mypy-boto3-es =
    buildMypyBoto3Package "es" "1.37.0"
      "sha256-jKo/VYOtHEWPFh3w0Q3rg3nlreizEcNG7C/eADRNy88=";

  mypy-boto3-events =
    buildMypyBoto3Package "events" "1.37.35"
      "sha256-HIZTGaVSNsddZxDxenpzNFWZDvV7Hl21ZKVfbGYYF9g=";

  mypy-boto3-evidently =
    buildMypyBoto3Package "evidently" "1.37.0"
      "sha256-MQJMX5Zv1/Cdd70NJZCXsMe3y9YLWvELE/u+gDfgLfc=";

  mypy-boto3-finspace =
    buildMypyBoto3Package "finspace" "1.37.0"
      "sha256-rrHDyRHjXMwNF1s52zi81o9fQnvzfJnNFQYYHK1lwy8=";

  mypy-boto3-finspace-data =
    buildMypyBoto3Package "finspace-data" "1.37.0"
      "sha256-MNUVaGlc2+UUEePFnslKpti//rJddHW4NZ8yZdOuQBU=";

  mypy-boto3-firehose =
    buildMypyBoto3Package "firehose" "1.37.38"
      "sha256-yJ0qwf+3vVS7l4tXqCPC44vvCTXJrDDQ5q5cArRSjqM=";

  mypy-boto3-fis =
    buildMypyBoto3Package "fis" "1.37.0"
      "sha256-fe2N065m93H+/0dUe2Q5yFjGVFDG/Gxq1jU1mYKtcOU=";

  mypy-boto3-fms =
    buildMypyBoto3Package "fms" "1.37.0"
      "sha256-0Z6WKKbucAFPy5MQkxblr4TUC7lLAp+0yJc4t4gE2X0=";

  mypy-boto3-forecast =
    buildMypyBoto3Package "forecast" "1.37.0"
      "sha256-6sweonHO2L2Ff98CGtuFdD2q3RGWy9rlk0NV8l0hvcg=";

  mypy-boto3-forecastquery =
    buildMypyBoto3Package "forecastquery" "1.37.0"
      "sha256-fBOuX8kCfMYEiATBBuMBdkT8YdvmDB6JshkvO06j4Hw=";

  mypy-boto3-frauddetector =
    buildMypyBoto3Package "frauddetector" "1.37.0"
      "sha256-06+v/pedzD+5J+6vPmGLf07cHkTm7h2y0oDs0bU3WsE=";

  mypy-boto3-fsx =
    buildMypyBoto3Package "fsx" "1.37.0"
      "sha256-wPym6XJ09JuqPS5ee+5iU4jXrtCiSutNE7BiZvP9w2A=";

  mypy-boto3-gamelift =
    buildMypyBoto3Package "gamelift" "1.37.22"
      "sha256-5wycchIRl8vzVHyYzW5WoNckIIYjyUZHEv7vMmtarU4=";

  mypy-boto3-glacier =
    buildMypyBoto3Package "glacier" "1.37.0"
      "sha256-H/k893rbdr/Z8h8eP2bO5hWnwYNsgSWpXSPaBa/DPHs=";

  mypy-boto3-globalaccelerator =
    buildMypyBoto3Package "globalaccelerator" "1.37.0"
      "sha256-JSVZVCZ6P5A+EqjXHmbbDIdE1rKrdSwNcZvUbYxKpSA=";

  mypy-boto3-glue =
    buildMypyBoto3Package "glue" "1.37.31"
      "sha256-wUofbzr8JoxrbsxVgiOTFdZBObxLml6yOqTVItV73eE=";

  mypy-boto3-grafana =
    buildMypyBoto3Package "grafana" "1.37.0"
      "sha256-KE/Dg7NPJ+bXLCMypEpgcVrsBnp8HebDVmu39f/30QQ=";

  mypy-boto3-greengrass =
    buildMypyBoto3Package "greengrass" "1.37.0"
      "sha256-J6QYTDL4NBIWagP60OUXk1O+RcS6jYk53XSimlBBVeM=";

  mypy-boto3-greengrassv2 =
    buildMypyBoto3Package "greengrassv2" "1.37.0"
      "sha256-RVay0BEbaqtWdNpJo3eswTIq+rRnLuDPRcvOPsrl8xQ=";

  mypy-boto3-groundstation =
    buildMypyBoto3Package "groundstation" "1.37.31"
      "sha256-sdfOAC4jlcz8AjessEO2u9NWbBqM3CCL6oJrJHYG6wk=";

  mypy-boto3-guardduty =
    buildMypyBoto3Package "guardduty" "1.37.0"
      "sha256-wF0XGOfuNYHC0nYnK5Ex+MHwPizLSuBUjcsUJTyWq8w=";

  mypy-boto3-health =
    buildMypyBoto3Package "health" "1.37.0"
      "sha256-yjDwz0QBJliUJSmyEt4DAgDujGITCdBVOnjV+C3zhT8=";

  mypy-boto3-healthlake =
    buildMypyBoto3Package "healthlake" "1.37.0"
      "sha256-cLuH24dACvIWq9+UDtLaeIXe8V7o8lz5oltGD94tTrU=";

  mypy-boto3-iam =
    buildMypyBoto3Package "iam" "1.37.22"
      "sha256-f3FqgcCMJeapoZA+nyZGndRDJ88qLX9km5R9ymLXnsY=";

  mypy-boto3-identitystore =
    buildMypyBoto3Package "identitystore" "1.37.0"
      "sha256-gwoKfNwNCaKDnPcTDIj5+H3M0xPwgafyQiYxZEEHABI=";

  mypy-boto3-imagebuilder =
    buildMypyBoto3Package "imagebuilder" "1.37.0"
      "sha256-9YhNPBhrgqEcZfJ91StQOu44p6XEyUTpOjq45mLBOi0=";

  mypy-boto3-importexport =
    buildMypyBoto3Package "importexport" "1.37.0"
      "sha256-CzJQ+aqu8YRRuywzXXkf9yUuqbfvabjbV76vmBwvndc=";

  mypy-boto3-inspector =
    buildMypyBoto3Package "inspector" "1.37.0"
      "sha256-RgmXpEJXEw/FOdxuiSs09BAhsgb4WBJj6/icuM7uCrI=";

  mypy-boto3-inspector2 =
    buildMypyBoto3Package "inspector2" "1.37.11"
      "sha256-5zb3wzEZ5fud8fJw125X79wuJNO2Jt+n606fgUpWW3Q=";

  mypy-boto3-internetmonitor =
    buildMypyBoto3Package "internetmonitor" "1.37.0"
      "sha256-VoOeyU+V9ciGtDBFwJeagMuPCXDjoSf8kUneJzhDarE=";

  mypy-boto3-iot =
    buildMypyBoto3Package "iot" "1.37.1"
      "sha256-yS8p0zWNgzASA6X3JEwJJSytmwbYbomgNe1xiWYHDok=";

  mypy-boto3-iot-data =
    buildMypyBoto3Package "iot-data" "1.37.0"
      "sha256-EZea0vo3qwFbk1EvVpCJBPAiz/8P0yWeREKr7mfZnlg=";

  mypy-boto3-iot-jobs-data =
    buildMypyBoto3Package "iot-jobs-data" "1.37.0"
      "sha256-Xak4A3V1bMl4qik6MHlmFW/ex1koGw4LR9aYb205vEg=";

  mypy-boto3-iot1click-devices =
    buildMypyBoto3Package "iot1click-devices" "1.35.93"
      "sha256-fwfuhSitYIJW5QswYdZ8ZpNL3AEg6MXhJitbbU48STs=";

  mypy-boto3-iot1click-projects =
    buildMypyBoto3Package "iot1click-projects" "1.35.93"
      "sha256-LFuz5/nCZGpSfgqyswxn80VzxXsqzZlBFqPtPJ8bzgo=";

  mypy-boto3-iotanalytics =
    buildMypyBoto3Package "iotanalytics" "1.37.0"
      "sha256-MkN78IyKgcYtxaaPYrtHXz8Ul4flgWiFD2Nyuc2hHHw=";

  mypy-boto3-iotdeviceadvisor =
    buildMypyBoto3Package "iotdeviceadvisor" "1.37.0"
      "sha256-EVk8HhXnmIH56aLsXl8RPZ8C2c6ydoHuLMmLJ49WgOA=";

  mypy-boto3-iotevents =
    buildMypyBoto3Package "iotevents" "1.37.0"
      "sha256-Tyu9+nPR1sjk6ta3f758RJEn6KdJjByZQhlqc36VMSI=";

  mypy-boto3-iotevents-data =
    buildMypyBoto3Package "iotevents-data" "1.37.0"
      "sha256-MSjysM2CdZr4R5lyboQJsGv8K1N5wZN8PbxPxWs0AXQ=";

  mypy-boto3-iotfleethub =
    buildMypyBoto3Package "iotfleethub" "1.37.0"
      "sha256-eEq8LDmORpA464IecxTI6FqVIitn3t+t4ElsHkfSAs4=";

  mypy-boto3-iotfleetwise =
    buildMypyBoto3Package "iotfleetwise" "1.37.36"
      "sha256-Rua+n9vvAiLAzy/DwDd6ErujD04q1Xsts0nle0KbUH0=";

  mypy-boto3-iotsecuretunneling =
    buildMypyBoto3Package "iotsecuretunneling" "1.37.0"
      "sha256-cbEk1zLlN9p39j2ieLX0cnbazR/pp/tcBB2lDM80c04=";

  mypy-boto3-iotsitewise =
    buildMypyBoto3Package "iotsitewise" "1.37.6"
      "sha256-orP5EctM9M8hGTIMNcFjKlWLm4CNKR9KjQo3yUqPTlY=";

  mypy-boto3-iotthingsgraph =
    buildMypyBoto3Package "iotthingsgraph" "1.37.0"
      "sha256-4AyJ/+SE5u2hIWgi6K1sfiLmSyd899H1swQR6gTo9fY=";

  mypy-boto3-iottwinmaker =
    buildMypyBoto3Package "iottwinmaker" "1.37.0"
      "sha256-/YnQXdkazAjklYHhxykdLgQ1ciLXODg37e2NwLnqtJI=";

  mypy-boto3-iotwireless =
    buildMypyBoto3Package "iotwireless" "1.37.19"
      "sha256-AOMp/Xagz6ybETbi0/pql+pyaTrup2cov/mUuU0PyWI=";

  mypy-boto3-ivs =
    buildMypyBoto3Package "ivs" "1.37.0"
      "sha256-62NDO0fNYeXWPqgst4EtVywX55vN5x7+1Qv2Q0IxxKg=";

  mypy-boto3-ivs-realtime =
    buildMypyBoto3Package "ivs-realtime" "1.37.12"
      "sha256-sSH33FBgOVDUmxzWGJzZvgpPpVI0cGXGiU7q10/W94U=";

  mypy-boto3-ivschat =
    buildMypyBoto3Package "ivschat" "1.37.0"
      "sha256-qX3KU2/BAPKyPX8mZ6kMbfUtZT35rbUx/YgVjicq85k=";

  mypy-boto3-kafka =
    buildMypyBoto3Package "kafka" "1.37.0"
      "sha256-SiyXSrw7tNj9C9LAYdjp8kXu/nEJ2asX3bEPgZUcKTg=";

  mypy-boto3-kafkaconnect =
    buildMypyBoto3Package "kafkaconnect" "1.37.0"
      "sha256-hrYoNIGeKC6JMmMtQQnORTBx6MF1M6n/ZZnq1AIzhhg=";

  mypy-boto3-kendra =
    buildMypyBoto3Package "kendra" "1.37.0"
      "sha256-TENeNcqFKxiOIAaFPZNhyQga812AFTHPjmZnDlYlLKg=";

  mypy-boto3-kendra-ranking =
    buildMypyBoto3Package "kendra-ranking" "1.37.0"
      "sha256-WL8F1hFsE+GyJvWY8CFrDHN14KD98RcsSv3+1uwAVQM=";

  mypy-boto3-keyspaces =
    buildMypyBoto3Package "keyspaces" "1.37.20"
      "sha256-zHtz1D1IqSJseHBWTQFekj6QlhsiHInPy15Wd35yjng=";

  mypy-boto3-kinesis =
    buildMypyBoto3Package "kinesis" "1.37.0"
      "sha256-W3ivXrEvOQrLH17MuXDsFxKUrUaOo3PQmpq0uyaj1ys=";

  mypy-boto3-kinesis-video-archived-media =
    buildMypyBoto3Package "kinesis-video-archived-media" "1.37.0"
      "sha256-t5Z7T540M+ifCdUT1cV04PKqERHzW0XIqKwvYMQ5od4=";

  mypy-boto3-kinesis-video-media =
    buildMypyBoto3Package "kinesis-video-media" "1.37.0"
      "sha256-CUsiSPwQJLvTI8nzdd55SbbUtNoLvwEWEM/zO0CCzWs=";

  mypy-boto3-kinesis-video-signaling =
    buildMypyBoto3Package "kinesis-video-signaling" "1.37.0"
      "sha256-hPyjF0zdzH8UwiAK7OqQffbl0r75L7KAkAaVWNFmOE4=";

  mypy-boto3-kinesis-video-webrtc-storage =
    buildMypyBoto3Package "kinesis-video-webrtc-storage" "1.37.0"
      "sha256-/iPSMr9pwqbAmj+5E1Igc2rgbwaKlvRG0w3x4mWBzzw=";

  mypy-boto3-kinesisanalytics =
    buildMypyBoto3Package "kinesisanalytics" "1.37.0"
      "sha256-b8REBC4pkmUyhl9uln1E7ugPIsxop6XdoOA1xOLymtc=";

  mypy-boto3-kinesisanalyticsv2 =
    buildMypyBoto3Package "kinesisanalyticsv2" "1.37.0"
      "sha256-IJ9ebOx1DVer16v7ck4n873BESC4gIFZi4QEmoILiPc=";

  mypy-boto3-kinesisvideo =
    buildMypyBoto3Package "kinesisvideo" "1.37.0"
      "sha256-Yb8XHqU2aHqiVH+134wOd7qRgjzJiVz8h6MgidjFXOo=";

  mypy-boto3-kms =
    buildMypyBoto3Package "kms" "1.37.0"
      "sha256-5wgeRfBkLbX35PGmGBciTx8gVS8Uqsh5WG8NeQwmEJs=";

  mypy-boto3-lakeformation =
    buildMypyBoto3Package "lakeformation" "1.37.13"
      "sha256-E5A6wS8kwjG1rWo1RFT7kwpqmWKGZ7UAmcR4KUvUrzg=";

  mypy-boto3-lambda =
    buildMypyBoto3Package "lambda" "1.37.16"
      "sha256-1Y8guwQWrrBP2mz6qKLywxUyylAJAEw+K8vorFCoz3w=";

  mypy-boto3-lex-models =
    buildMypyBoto3Package "lex-models" "1.37.0"
      "sha256-LmRJQh2p+bKkJH6wBcMcKvPTc+CV+CphIGeiNyZaMNM=";

  mypy-boto3-lex-runtime =
    buildMypyBoto3Package "lex-runtime" "1.37.0"
      "sha256-LCz2bmZAf1T0ueQOb4H8tfqc7tubGtBRYbmk4GfseKA=";

  mypy-boto3-lexv2-models =
    buildMypyBoto3Package "lexv2-models" "1.37.26"
      "sha256-sLXJPo0qerWMMGKkpEqPKTc4fKSl6ryZIxwfWCHgYKQ=";

  mypy-boto3-lexv2-runtime =
    buildMypyBoto3Package "lexv2-runtime" "1.37.0"
      "sha256-b3JBnwLTABHj8XaNjhKHjuFscmcO29JnFFtK5v6Ak1I=";

  mypy-boto3-license-manager =
    buildMypyBoto3Package "license-manager" "1.37.0"
      "sha256-duHIjwoXugFgIxsT51/G1+a1O9gMYKPOn+8CXkfDlVc=";

  mypy-boto3-license-manager-linux-subscriptions =
    buildMypyBoto3Package "license-manager-linux-subscriptions" "1.37.0"
      "sha256-KolHBiYkyFntiOh7fbFytnhfKhnz+/jkXI1PpD9lIzo=";

  mypy-boto3-license-manager-user-subscriptions =
    buildMypyBoto3Package "license-manager-user-subscriptions" "1.37.0"
      "sha256-Q3LbIvZgdUj+M4miKLCmvJ/8xwKniGDzslapBVKrmR0=";

  mypy-boto3-lightsail =
    buildMypyBoto3Package "lightsail" "1.37.0"
      "sha256-h2JU5d5xFlRFmubn04Fj1IpmChHuopFM9m5NOGjB7xE=";

  mypy-boto3-location =
    buildMypyBoto3Package "location" "1.37.0"
      "sha256-PcBNOGGOtp+7V8UTqWIICoT0GjzYIx+XXx65neIfP9Q=";

  mypy-boto3-logs =
    buildMypyBoto3Package "logs" "1.37.12"
      "sha256-GEVHpH3q5NBtPza5PRi5dC1Vvwm2bcSOxKnnDHmp4to=";

  mypy-boto3-lookoutequipment =
    buildMypyBoto3Package "lookoutequipment" "1.37.0"
      "sha256-hXtY7MFv7O8Xu7FYUCeOQNnkSQNpaaMna4I97T7L4Yg=";

  mypy-boto3-lookoutmetrics =
    buildMypyBoto3Package "lookoutmetrics" "1.37.0"
      "sha256-DKOnbmgF1khWJ2IJBB/B8Y+3aleNAJqiKdd0H+3thf4=";

  mypy-boto3-lookoutvision =
    buildMypyBoto3Package "lookoutvision" "1.37.0"
      "sha256-9lGnqh0rDZ7/rwRXCjsbuukQPQmXjAVWo3JLx54S+j0=";

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
