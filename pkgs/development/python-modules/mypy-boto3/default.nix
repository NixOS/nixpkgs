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

      src = fetchPypi {
        pname = "mypy_boto3_${toUnderscore serviceName}";
        inherit version hash;
      };

      build-system = [ setuptools ];

      dependencies = [ boto3 ] ++ lib.optionals (pythonOlder "3.12") [ typing-extensions ];

      # Project has no tests
      doCheck = false;

      pythonImportsCheck = [ "mypy_boto3_${toUnderscore serviceName}" ];

      meta = {
        description = "Type annotations for boto3 ${serviceName}";
        homepage = "https://github.com/youtype/mypy_boto3_builder";
        license = lib.licenses.mit;
        maintainers = with lib.maintainers; [
          fab
        ];
      };
    };
in
{
  mypy-boto3-accessanalyzer =
    buildMypyBoto3Package "accessanalyzer" "1.44.0"
      "sha256-ZKjrVwhkuECLIa2YYfMqzhZKl51Yp9CV7l2Q8B2Lcfo=";

  mypy-boto3-account =
    buildMypyBoto3Package "account" "1.44.0"
      "sha256-Jncyct0wM9xOdJluWEuRuMNYnYJH+8dBuhCDpEs9X7g=";

  mypy-boto3-acm =
    buildMypyBoto3Package "acm" "1.44.0"
      "sha256-XqtK5TlfsVW/B8eAGmuGQCu0MT9g1AErvd+PFNkenyI=";

  mypy-boto3-acm-pca =
    buildMypyBoto3Package "acm-pca" "1.44.1"
      "sha256-SQQ8z+MwFzC40ng1jLqrVNAayHGw8SaKG27Ld3VPPUQ=";

  mypy-boto3-amp =
    buildMypyBoto3Package "amp" "1.44.0"
      "sha256-cMpbZv/fAINdSaQUCPQ4JlkiHi0KUwqX/IrSTq8OIlY=";

  mypy-boto3-amplify =
    buildMypyBoto3Package "amplify" "1.44.0"
      "sha256-a3/aRfx8uvdk6SixX0LlModZZp7DooqdB9vjzRODYSA=";

  mypy-boto3-amplifybackend =
    buildMypyBoto3Package "amplifybackend" "1.44.0"
      "sha256-NJRXFhQ6qocoXe/gr79NFyIMbZPKa4G0D2k1NeGP9D4=";

  mypy-boto3-amplifyuibuilder =
    buildMypyBoto3Package "amplifyuibuilder" "1.44.0"
      "sha256-zN8eKHLqOIWxBKti84XvvjXuf6rIAOV46zmswFN7Ehs=";

  mypy-boto3-apigateway =
    buildMypyBoto3Package "apigateway" "1.44.0"
      "sha256-v24/hRXoCubY2DskATFYhI+v7O4uYKSCtGB1jJxEDSc=";

  mypy-boto3-apigatewaymanagementapi =
    buildMypyBoto3Package "apigatewaymanagementapi" "1.44.0"
      "sha256-GfOhCq/aqVMwY5jAVIUhKQlD6E9hG3Hgi2yWFxTfVos=";

  mypy-boto3-apigatewayv2 =
    buildMypyBoto3Package "apigatewayv2" "1.44.0"
      "sha256-S0NGFJfwWuf/Rv7Xnol1uGDcXIDbckSJQjMtyDX34k0=";

  mypy-boto3-appconfig =
    buildMypyBoto3Package "appconfig" "1.44.0"
      "sha256-kHfcK6YeJzzMcjLOzieLjHF3YDpZOKbeFQm4vWT6w1Q=";

  mypy-boto3-appconfigdata =
    buildMypyBoto3Package "appconfigdata" "1.44.0"
      "sha256-QIHBuNdoUxZSMRWmkCjPFXSxHzx1/3n1ppOTkXSoT4A=";

  mypy-boto3-appfabric =
    buildMypyBoto3Package "appfabric" "1.44.0"
      "sha256-rNsoHTotxumn5u2Ea+0cF/BX1UD3SxEZdPcYWezjQpY=";

  mypy-boto3-appflow =
    buildMypyBoto3Package "appflow" "1.44.0"
      "sha256-pqrFqLQaaqgfT1z++EyHezwR8MUV7Zswj4s1OLQvF4A=";

  mypy-boto3-appintegrations =
    buildMypyBoto3Package "appintegrations" "1.44.0"
      "sha256-b8bnC/fq6HC1MTjU99ZenTCfpOC6EWAvqiuhTTnd6ug=";

  mypy-boto3-application-autoscaling =
    buildMypyBoto3Package "application-autoscaling" "1.44.0"
      "sha256-miQu4Y6egWNXvI57OPxk2T069LxQcEOkedIWJ//LQG8=";

  mypy-boto3-application-insights =
    buildMypyBoto3Package "application-insights" "1.44.0"
      "sha256-BTGmejwvF15bk7FXy+dtED23PFgFspFLsFcdFggsXL8=";

  mypy-boto3-applicationcostprofiler =
    buildMypyBoto3Package "applicationcostprofiler" "1.44.0"
      "sha256-vWDt4cXRP70sNeIUQqSI8wf8zRpMl74ww+/y6az+6Ic=";

  mypy-boto3-appmesh =
    buildMypyBoto3Package "appmesh" "1.44.0"
      "sha256-Cce7GjuIQ1+ygfHu+v0cD06uTrpoKlwtY9xaZBmSxkg=";

  mypy-boto3-apprunner =
    buildMypyBoto3Package "apprunner" "1.44.0"
      "sha256-lqJ71yBDBos/5y0fUH5qClF6nbaAz1/Xw01VjBtXuss=";

  mypy-boto3-appstream =
    buildMypyBoto3Package "appstream" "1.44.0"
      "sha256-XfrL1Bg+sEpoTfUZST3oI0JpSeDj4MgI4bDGJ0MQSrY=";

  mypy-boto3-appsync =
    buildMypyBoto3Package "appsync" "1.44.0"
      "sha256-nXz1Cd6Oeada/vjDQY3tlCcbPAVKmcw49ozgnnU8HvU=";

  mypy-boto3-arc-zonal-shift =
    buildMypyBoto3Package "arc-zonal-shift" "1.44.0"
      "sha256-FyldpLYeUMJe3YMXdhgffb8he0jkE2RQqNDZEbqSM5A=";

  mypy-boto3-athena =
    buildMypyBoto3Package "athena" "1.44.0"
      "sha256-T/ensozXBy0hvCA4Oxz5ZeGdrHb065wFzL0waYBy/6s=";

  mypy-boto3-auditmanager =
    buildMypyBoto3Package "auditmanager" "1.44.0"
      "sha256-44Ix439NagdB/Ui2MnK0S6bQKe1sswoOmeIcGETjF/o=";

  mypy-boto3-autoscaling =
    buildMypyBoto3Package "autoscaling" "1.44.0"
      "sha256-hEmy/yeG2cT16cdRgPwhu6s2GKDYChag3gmQPCmvgho=";

  mypy-boto3-autoscaling-plans =
    buildMypyBoto3Package "autoscaling-plans" "1.44.0"
      "sha256-eRDFA25BJOZh6miBA1shRQmYAXivq4WT34m3AVDcvjI=";

  mypy-boto3-backup =
    buildMypyBoto3Package "backup" "1.44.0"
      "sha256-C1uu84RHei6dBJVrpwd2njG6Bj69BKOUtRLj2EocuXc=";

  mypy-boto3-backup-gateway =
    buildMypyBoto3Package "backup-gateway" "1.44.0"
      "sha256-nrze0BX1PnNV5O4+RhG6Dt1xfpUj0mGO/+lX2u+Hvh8=";

  mypy-boto3-batch =
    buildMypyBoto3Package "batch" "1.44.0"
      "sha256-ny806RuP4di2MHVtJLUXnuLi804iRYzqFf4N0RjqKPM=";

  mypy-boto3-billingconductor =
    buildMypyBoto3Package "billingconductor" "1.44.0"
      "sha256-ptCCuAhNA7Wlw2yYqKHU3w8YwgGpl204dWllHSBMQR4=";

  mypy-boto3-braket =
    buildMypyBoto3Package "braket" "1.44.0"
      "sha256-aQhTdAcGRSH/h0PxSXrZov015MiYS7RrFHn+yfeiWOs=";

  mypy-boto3-budgets =
    buildMypyBoto3Package "budgets" "1.44.0"
      "sha256-Kki3EhUWb/k7TgciMzVC4i56srCL51GFV9BlRhVewLY=";

  mypy-boto3-ce =
    buildMypyBoto3Package "ce" "1.44.0"
      "sha256-XY/OHJKZZvODm8M2TbXAtBQzMase0QORFSmndUVXP9A=";

  mypy-boto3-chime =
    buildMypyBoto3Package "chime" "1.44.0"
      "sha256-grSmFdAOEod9lLhFAZ0df1nh0VgLpH6FXk8kRTfS/dU=";

  mypy-boto3-chime-sdk-identity =
    buildMypyBoto3Package "chime-sdk-identity" "1.44.0"
      "sha256-idl8Flv9iuINTZxjNp4EVz8XDC9+L0p+13Ydz3Y1hho=";

  mypy-boto3-chime-sdk-media-pipelines =
    buildMypyBoto3Package "chime-sdk-media-pipelines" "1.44.0"
      "sha256-HQt4mX6hq1EyURDVfQpJGiJDP2I5QX+GKgjhvmwJcxE=";

  mypy-boto3-chime-sdk-meetings =
    buildMypyBoto3Package "chime-sdk-meetings" "1.44.0"
      "sha256-MOs+/ftQWeAMrBE7NESFGcIcJYCRU/wIE2Dlmg0JFos=";

  mypy-boto3-chime-sdk-messaging =
    buildMypyBoto3Package "chime-sdk-messaging" "1.44.0"
      "sha256-r0bGqPNHTuDUOPXGRpOCmNTnWwK4C1o0nyZEtPnMPTM=";

  mypy-boto3-chime-sdk-voice =
    buildMypyBoto3Package "chime-sdk-voice" "1.44.0"
      "sha256-nvEcTYzI6seVmTfUEwftmeDR2Dd3EdFSc1/A2Wp9AjM=";

  mypy-boto3-cleanrooms =
    buildMypyBoto3Package "cleanrooms" "1.44.0"
      "sha256-FOZY/LLTnDgQC+BukapV5adK25vfgzTRlbGJJVNMTYs=";

  mypy-boto3-cloud9 =
    buildMypyBoto3Package "cloud9" "1.44.0"
      "sha256-r8x9JJGlpwt4XsxnuKQjeGRYzSPLgvwYKEo4ssqQz9o=";

  mypy-boto3-cloudcontrol =
    buildMypyBoto3Package "cloudcontrol" "1.44.0"
      "sha256-ncZ7f1d0ZqqhUfHuOf+B/TkWJ4qKnaI3jcMup0fS7tY=";

  mypy-boto3-clouddirectory =
    buildMypyBoto3Package "clouddirectory" "1.44.0"
      "sha256-sxA5hor4KNpFidS/POwwYnN+gC4XdKTCS6DkpPicatg=";

  mypy-boto3-cloudformation =
    buildMypyBoto3Package "cloudformation" "1.44.0"
      "sha256-ISN4VGZVpUoa3BHSha79iqzSN/W4Vo560nAXLX3+R+8=";

  mypy-boto3-cloudfront =
    buildMypyBoto3Package "cloudfront" "1.44.0"
      "sha256-oM97nm311j/8+XkQy0Vz6Lg7gZRo2TkuKOxtHIv70R4=";

  mypy-boto3-cloudhsm =
    buildMypyBoto3Package "cloudhsm" "1.44.0"
      "sha256-AJqAYFWEDK4sI0seK+uF1mpDfuyqOt91iV9sonDbmlM=";

  mypy-boto3-cloudhsmv2 =
    buildMypyBoto3Package "cloudhsmv2" "1.44.1"
      "sha256-ZlXTZ8WGgJ5tQNpMIsCt0kvCvEmBw8rU0HqfjoF1OsA=";

  mypy-boto3-cloudsearch =
    buildMypyBoto3Package "cloudsearch" "1.44.0"
      "sha256-+Mlii1B/IoiWzMSv/mh7J9qnhb5dZq9Zwefc5L1sre0=";

  mypy-boto3-cloudsearchdomain =
    buildMypyBoto3Package "cloudsearchdomain" "1.44.0"
      "sha256-hHOr/qev8s6sMRaeXciqRWtDuqi1M7IuWL8jAeK7BmM=";

  mypy-boto3-cloudtrail =
    buildMypyBoto3Package "cloudtrail" "1.44.0"
      "sha256-7uvfcjiSMYsigcBJ3lK6PdKSDOT17iJ8W3JKdOKr96Y=";

  mypy-boto3-cloudtrail-data =
    buildMypyBoto3Package "cloudtrail-data" "1.44.0"
      "sha256-1RNAeYb7FCFWUvoqEFtvUISy82n8WlR0jbINBmfpoyY=";

  mypy-boto3-cloudwatch =
    buildMypyBoto3Package "cloudwatch" "1.44.0"
      "sha256-P/06IwXkWrq804B3JF1iTrMycz69oh7nI9D6JYuVV3g=";

  mypy-boto3-codeartifact =
    buildMypyBoto3Package "codeartifact" "1.44.0"
      "sha256-yVV+4tgo+Ze680SYvbx0HYCifqObesAU0qPAE2tnBS4=";

  mypy-boto3-codebuild =
    buildMypyBoto3Package "codebuild" "1.44.1"
      "sha256-RuFqkTjw0QICyxQyfI6ceRTzIXHY/1f5VJ3rIYsSjpc=";

  mypy-boto3-codecatalyst =
    buildMypyBoto3Package "codecatalyst" "1.44.0"
      "sha256-DJqr/sR5I1GxV53V5F3bckrU3e/D53TVs9wU2sIOHPg=";

  mypy-boto3-codecommit =
    buildMypyBoto3Package "codecommit" "1.44.0"
      "sha256-8VguNmIjvDnA8yV3yscNCI41eLPsiFqqB7AAICv8rGc=";

  mypy-boto3-codedeploy =
    buildMypyBoto3Package "codedeploy" "1.44.1"
      "sha256-tfcIBRc8z4J35zGpU672QkChoZ69O0guOVEuoOYnqnw=";

  mypy-boto3-codeguru-reviewer =
    buildMypyBoto3Package "codeguru-reviewer" "1.44.0"
      "sha256-z3nETGSfwCS1QfzcQ2UHGSgW44rID2/Vvz1PPQpwYIo=";

  mypy-boto3-codeguru-security =
    buildMypyBoto3Package "codeguru-security" "1.44.0"
      "sha256-rVA1GaK4UtJ61s8uHlnVAXv3SehkFHqJOBHA0CC/VXY=";

  mypy-boto3-codeguruprofiler =
    buildMypyBoto3Package "codeguruprofiler" "1.44.0"
      "sha256-Du84JaqpcEGPFMRrXZnsrtn4GJKyu4Ct4s4jiLYyXTI=";

  mypy-boto3-codepipeline =
    buildMypyBoto3Package "codepipeline" "1.44.1"
      "sha256-1sxhDhpwG0cuJoVueYj/r0ZIM6FjUg09mmQEhgKVyMQ=";

  mypy-boto3-codestar =
    buildMypyBoto3Package "codestar" "1.35.0"
      "sha256-B9Aq+hh9BOzCIYMkS21IZYb3tNCnKnV2OpSIo48aeJM=";

  mypy-boto3-codestar-connections =
    buildMypyBoto3Package "codestar-connections" "1.44.0"
      "sha256-pc0MAl9bfGPloIt28PuRjgNsPwIOy5fDYnFBOJ+yQrM=";

  mypy-boto3-codestar-notifications =
    buildMypyBoto3Package "codestar-notifications" "1.44.0"
      "sha256-GSGfbFRXSOk80EN7nw3MK3wgZDboJdvZBqjgYDrzHVg=";

  mypy-boto3-cognito-identity =
    buildMypyBoto3Package "cognito-identity" "1.44.0"
      "sha256-tpBcm33XysDigsqEOphEtXQk7MEqBZnjWlZP8KiwBz8=";

  mypy-boto3-cognito-idp =
    buildMypyBoto3Package "cognito-idp" "1.44.1"
      "sha256-dV2td+BlQPETOr0G013JOlRdsmeeF950TNY58Da93Fw=";

  mypy-boto3-cognito-sync =
    buildMypyBoto3Package "cognito-sync" "1.44.0"
      "sha256-9vJaTcwk6tugP5nXWLTYAVqeHcXO468HusAaHhYd2+I=";

  mypy-boto3-comprehend =
    buildMypyBoto3Package "comprehend" "1.44.1"
      "sha256-jIhJ89H/aFCUZ6Y+mJnD7DSbGd+T7JMnFnSg/UpjExM=";

  mypy-boto3-comprehendmedical =
    buildMypyBoto3Package "comprehendmedical" "1.44.0"
      "sha256-7fTiBDQhVg3bafWhrSUceL3wqKPyY9knBUBTLvHp3KU=";

  mypy-boto3-compute-optimizer =
    buildMypyBoto3Package "compute-optimizer" "1.44.0"
      "sha256-NWQTQY7M1kKGjbLex3VlWbcVbWTDib8NCRcYp12RX2M=";

  mypy-boto3-config =
    buildMypyBoto3Package "config" "1.44.1"
      "sha256-UhRUrwj+/kd3zRTPyK0kFiXeAq1r9G29Qntc+lQV8b0=";

  mypy-boto3-connect =
    buildMypyBoto3Package "connect" "1.44.1"
      "sha256-2ahNtyh17pHNwa0xaGr0REWv3T0Hfy6ZTU3mjl9tzrY=";

  mypy-boto3-connect-contact-lens =
    buildMypyBoto3Package "connect-contact-lens" "1.44.0"
      "sha256-vJnqO27umRyvkQZd68XUppIpic8OSPDyKgT6XetMzKQ=";

  mypy-boto3-connectcampaigns =
    buildMypyBoto3Package "connectcampaigns" "1.44.0"
      "sha256-oMkYi9sdfVRKku+v9dLckwviD7yHl8Pg6oAL1Z9QZnM=";

  mypy-boto3-connectcases =
    buildMypyBoto3Package "connectcases" "1.44.1"
      "sha256-MSMPLCi+wxqDNbL04pzBdKNaK2JFfEukcrPMRnNRw7I=";

  mypy-boto3-connectparticipant =
    buildMypyBoto3Package "connectparticipant" "1.44.0"
      "sha256-76rpNA87G945z/KOnKpQ99KWgKNS6sp53wIh4rn6DCA=";

  mypy-boto3-controltower =
    buildMypyBoto3Package "controltower" "1.44.0"
      "sha256-L0BCYp6uPd5u91DQzyPUY8wlTCT/OPvjk14/h24yfNc=";

  mypy-boto3-cur =
    buildMypyBoto3Package "cur" "1.44.0"
      "sha256-bSi5O0X+E8QhoKlKkT4CMOlmcc/SGlzxFxSwgmf4Raw=";

  mypy-boto3-customer-profiles =
    buildMypyBoto3Package "customer-profiles" "1.44.0"
      "sha256-wMwOGcnBbmwl6EGCzby/VjNvhEfvhymWRBPZupoIyoE=";

  mypy-boto3-databrew =
    buildMypyBoto3Package "databrew" "1.44.0"
      "sha256-PgH6PmMLrYLMhEiYhvFJXwvc3rWuGGb6bZP7LshxP/Y=";

  mypy-boto3-dataexchange =
    buildMypyBoto3Package "dataexchange" "1.44.0"
      "sha256-L4ghjLUYPnNJTzrp1q0ABzOlpsdV/qv3qqF6RFCHAOU=";

  mypy-boto3-datapipeline =
    buildMypyBoto3Package "datapipeline" "1.44.0"
      "sha256-FDEjPH5F5uHLbEXYHd93tjJxI9IIARZgUPlL0gL/3gY=";

  mypy-boto3-datasync =
    buildMypyBoto3Package "datasync" "1.44.1"
      "sha256-ox/QQ0hT4yFQE9UiI0H0zAQH0GQDSpvZnfKFIkTHr/g=";

  mypy-boto3-dax =
    buildMypyBoto3Package "dax" "1.44.0"
      "sha256-zr47k2YV3WHv4LBF0OwQIIuHvg8PDyek3say/IElQ7w=";

  mypy-boto3-detective =
    buildMypyBoto3Package "detective" "1.44.0"
      "sha256-Yu4X4IMJylI7wfbbM7qf+fEqjASO4B7s4D2j8VQFtKk=";

  mypy-boto3-devicefarm =
    buildMypyBoto3Package "devicefarm" "1.44.0"
      "sha256-CHsIakj/plq1A2oxR0JivarVrBG9cZUiC7f2XYe8y9U=";

  mypy-boto3-devops-guru =
    buildMypyBoto3Package "devops-guru" "1.44.0"
      "sha256-BiEHs5iqoFooRFL+BqxTRDrBQgzWzzaMfMBlU+QqBN4=";

  mypy-boto3-directconnect =
    buildMypyBoto3Package "directconnect" "1.44.1"
      "sha256-G8oA8dku1ktSPVBW88+wl8Ge+SChBeJRbTiLM9JLH0k=";

  mypy-boto3-discovery =
    buildMypyBoto3Package "discovery" "1.44.0"
      "sha256-u6i3fJH4Yrq184pZaSu0yTmMoX/M1klPvAcU0JKalFQ=";

  mypy-boto3-dlm =
    buildMypyBoto3Package "dlm" "1.44.0"
      "sha256-2P9ZsVJFrQpzvA1sgXrN9BGsxlZhJX/ipvRqfg2zdXI=";

  mypy-boto3-dms =
    buildMypyBoto3Package "dms" "1.44.0"
      "sha256-b+SPfOsgHCAF69YkfHDlAsWy40kDjVk8HRfEwz4Gjj0=";

  mypy-boto3-docdb =
    buildMypyBoto3Package "docdb" "1.44.0"
      "sha256-f/jga3Z/pWLdYEgmLgcxZBRJ6bOSCqvpH/nm/xw2d24=";

  mypy-boto3-docdb-elastic =
    buildMypyBoto3Package "docdb-elastic" "1.44.0"
      "sha256-CnZV3A9UbznjvjtYIqBaES/vjeALzH+I20ul0018NqA=";

  mypy-boto3-drs =
    buildMypyBoto3Package "drs" "1.44.0"
      "sha256-PGVZDTpXHWzJJRQRynT8yW6YtUIXVpl01P+CFcTilNA=";

  mypy-boto3-ds =
    buildMypyBoto3Package "ds" "1.44.1"
      "sha256-YwIUjyMW933IO7GYORCFW6Bw1ZE0HduXEoVPQSwmSwQ=";

  mypy-boto3-dynamodb =
    buildMypyBoto3Package "dynamodb" "1.44.0"
      "sha256-P9YZj6nraYkZwctmazqfMU0rbyJYw5IahKK+89R/Ldk=";

  mypy-boto3-dynamodbstreams =
    buildMypyBoto3Package "dynamodbstreams" "1.44.0"
      "sha256-ty08zCwP+Qql7xB+zaqJZksTPjDS5aFbtYod+tNpNr4=";

  mypy-boto3-ebs =
    buildMypyBoto3Package "ebs" "1.44.0"
      "sha256-8bU5bePN3fhzl37c+bCBBST10W5YVatCle+ckcXV74I=";

  mypy-boto3-ec2 =
    buildMypyBoto3Package "ec2" "1.44.1"
      "sha256-qUdAGgJ06355DQqoerU0ScSfzM9+TBOn4+1Zu1eGS1M=";

  mypy-boto3-ec2-instance-connect =
    buildMypyBoto3Package "ec2-instance-connect" "1.44.0"
      "sha256-eC0hbSSUD70LUsUPkTuVdxD7m5dYFfcNVC59sFk5rsg=";

  mypy-boto3-ecr =
    buildMypyBoto3Package "ecr" "1.44.0"
      "sha256-/XTJ0lJF5V08OG7Dn3tBMy5sYXRUf7pCiHKtpTFXPg4=";

  mypy-boto3-ecr-public =
    buildMypyBoto3Package "ecr-public" "1.44.0"
      "sha256-HjhqkX3noqy4XsquHNM3pRqx+fd7LjlDfEdSB2j1vjo=";

  mypy-boto3-ecs =
    buildMypyBoto3Package "ecs" "1.44.0"
      "sha256-tuQ3vJWTIELuNYlYeyGzWrcXJI/JUzjCCYzBfV/rVZ8=";

  mypy-boto3-efs =
    buildMypyBoto3Package "efs" "1.44.0"
      "sha256-zum8BQIQMFbSxnIjZr6OBJy8piuQg/55Tha1ICxprr4=";

  mypy-boto3-eks =
    buildMypyBoto3Package "eks" "1.44.0"
      "sha256-DcTzblXxztH32zFwlC4CAvvW+3MohILHqsQvKOq448k=";

  mypy-boto3-elastic-inference =
    buildMypyBoto3Package "elastic-inference" "1.36.0"
      "sha256-duU3LIeW3FNiplVmduZsNXBoDK7vbO6ecrBt1Y7C9rU=";

  mypy-boto3-elasticache =
    buildMypyBoto3Package "elasticache" "1.44.0"
      "sha256-m6Z58bJcwOXLsMLJbJABX6ji3tMbQ9Z4WD1yp/tpCT8=";

  mypy-boto3-elasticbeanstalk =
    buildMypyBoto3Package "elasticbeanstalk" "1.44.0"
      "sha256-fPNvA9k1Zx3sxRN3ETfrsOophp4JBYo3IOp9f3hrieQ=";

  mypy-boto3-elastictranscoder =
    buildMypyBoto3Package "elastictranscoder" "1.42.3"
      "sha256-6fH7Mf2p9tYmendYBCHXKo+6NKkRP2j2ofLTrkxlrtU=";

  mypy-boto3-elb =
    buildMypyBoto3Package "elb" "1.44.0"
      "sha256-8RIRHfVRtNpwN4FGXFPZ1eVgBIAHsRdEpSoxhHa1kWQ=";

  mypy-boto3-elbv2 =
    buildMypyBoto3Package "elbv2" "1.44.0"
      "sha256-DMqMxg82PMIuyumvdroD1y4Mt1lDX//+A8IEGdIDAy0=";

  mypy-boto3-emr =
    buildMypyBoto3Package "emr" "1.44.0"
      "sha256-ac1scacBklkpXE7Cs8dckA6cY1G8WFg2ZfvCdfjjh2M=";

  mypy-boto3-emr-containers =
    buildMypyBoto3Package "emr-containers" "1.44.0"
      "sha256-N+44oox12McBmcuW+Lj0aJxOKajC3dyGpbg/JTRi+IA=";

  mypy-boto3-emr-serverless =
    buildMypyBoto3Package "emr-serverless" "1.44.0"
      "sha256-m0NU266WBIzHnG6A+C8Uh6ch82o2C6MXuABTzs3/0Bs=";

  mypy-boto3-entityresolution =
    buildMypyBoto3Package "entityresolution" "1.44.0"
      "sha256-q3GVLGdqADJYU+AnzerX2JFrILqe4uTlxBMubr7OJ9M=";

  mypy-boto3-es =
    buildMypyBoto3Package "es" "1.44.0"
      "sha256-F8Y5qtAVUw9va8MH7B/+r9lS5uxxA5cuzPJBj2iTsLo=";

  mypy-boto3-events =
    buildMypyBoto3Package "events" "1.44.0"
      "sha256-nugl94CG6zVWyZ/wQVzlv3oj5ARjq7gCvyEhEnSnON4=";

  mypy-boto3-evidently =
    buildMypyBoto3Package "evidently" "1.42.35"
      "sha256-kdSGsikyLazIdSKidTt6bk5i+syJgx/GE0y+KRpC1rw=";

  mypy-boto3-finspace =
    buildMypyBoto3Package "finspace" "1.43.0"
      "sha256-CjVX0pF3be2BNpJy/+zWJ7/YZSszPlLWgIL/Qo7jKoY=";

  mypy-boto3-finspace-data =
    buildMypyBoto3Package "finspace-data" "1.43.0"
      "sha256-bPKKphp64m4s7ceo0ypSfyqY/AGzqFkIWQksqDIRLSM=";

  mypy-boto3-firehose =
    buildMypyBoto3Package "firehose" "1.44.0"
      "sha256-lrvrYopThGYoQ2sHv99ZmfyLbVpcxpcnA5ZqyVyP70M=";

  mypy-boto3-fis =
    buildMypyBoto3Package "fis" "1.44.0"
      "sha256-6vRlZkMB25BqngXqmYzhMUE9a7iX9SpxNv5deb1fZUo=";

  mypy-boto3-fms =
    buildMypyBoto3Package "fms" "1.44.0"
      "sha256-Lc421qeNx7oncCZ1rauYsOwqnHVLfooNdzu3hZm3xuI=";

  mypy-boto3-forecast =
    buildMypyBoto3Package "forecast" "1.44.0"
      "sha256-qnBIjfKjwKIJuZq9RlEK2BA1iDtHyMSIwklsxIHIDlo=";

  mypy-boto3-forecastquery =
    buildMypyBoto3Package "forecastquery" "1.44.0"
      "sha256-jeJqwOiO3N3+0l89gwLY9gMN5MjS8oTv96y0FSgJddc=";

  mypy-boto3-frauddetector =
    buildMypyBoto3Package "frauddetector" "1.44.0"
      "sha256-V70JqgPlOtU+lsR89qwV9RIeUXDFTz+mGaF0ojGCrHQ=";

  mypy-boto3-fsx =
    buildMypyBoto3Package "fsx" "1.44.0"
      "sha256-m3bBAofXhyte1JvntpYk5WreusaMLtYfvvN/ARXE3sM=";

  mypy-boto3-gamelift =
    buildMypyBoto3Package "gamelift" "1.44.0"
      "sha256-NJZKouvHCPF5weMysc3MQJ4uiY8265p/oUZpT9PvEGE=";

  mypy-boto3-glacier =
    buildMypyBoto3Package "glacier" "1.44.0"
      "sha256-8YNelgWU/dkdSDQDKO/XfruiC2zFlb4CZjcfn/SFk7c=";

  mypy-boto3-globalaccelerator =
    buildMypyBoto3Package "globalaccelerator" "1.44.0"
      "sha256-UCaI9cKccZukd4zSGKqt2/RVVgnyPjKRDtDY1SmXZO0=";

  mypy-boto3-glue =
    buildMypyBoto3Package "glue" "1.44.0"
      "sha256-1HldhpB+mSlE0TehvKlgsMxT6lUKRgGdrGu9t2tDuZc=";
  mypy-boto3-grafana =
    buildMypyBoto3Package "grafana" "1.44.0"
      "sha256-Y7izWDvHFjzd1FaqzVaTohgDffB62ct1inGEJKQobhc=";

  mypy-boto3-greengrass =
    buildMypyBoto3Package "greengrass" "1.44.0"
      "sha256-JHPwrgS2BtTucVFihAYyCt4f8DMun+h2KYV9iL2A5zE=";

  mypy-boto3-greengrassv2 =
    buildMypyBoto3Package "greengrassv2" "1.44.0"
      "sha256-l0ldyKL0+O+TJt+Zy6ya+YWkvqrEknp7+tXgCP8nqt8=";

  mypy-boto3-groundstation =
    buildMypyBoto3Package "groundstation" "1.44.0"
      "sha256-jrDKEzVbWw7yMV42xcFga9AiFvpFnGWSMWptsLUZUG8=";

  mypy-boto3-guardduty =
    buildMypyBoto3Package "guardduty" "1.44.0"
      "sha256-dalgFZg9c4SVcb0EvbWlginW1CaMWWLGqDYB2EGWKjk=";

  mypy-boto3-health =
    buildMypyBoto3Package "health" "1.44.0"
      "sha256-eP26V8LzUx73lrSZC34hHhxgU2qOu4ERWUEIO//qhXw=";

  mypy-boto3-healthlake =
    buildMypyBoto3Package "healthlake" "1.44.0"
      "sha256-3ebU3awqDP7MC30zPAQrzf1nR6IK80K+b1kUum6HcG0=";

  mypy-boto3-iam =
    buildMypyBoto3Package "iam" "1.44.0"
      "sha256-8FVu+vuW5BBzuiiNNpFtqjWO+PB6hR70bj7ShtszWs4=";

  mypy-boto3-identitystore =
    buildMypyBoto3Package "identitystore" "1.44.1"
      "sha256-V04tlhTPIUtEGXMq6DRsO7Vwj4mUhS3hqFl2LWwDPZY=";

  mypy-boto3-imagebuilder =
    buildMypyBoto3Package "imagebuilder" "1.44.1"
      "sha256-Eezvc85FyqYFgATuTHe4txdrquar2oSPDFlDrJIyAoQ=";

  mypy-boto3-importexport =
    buildMypyBoto3Package "importexport" "1.44.0"
      "sha256-jFU3LB2Fcc0KY4duOc+8hDTHYOtSYz+x2Pnaef9Unf0=";

  mypy-boto3-inspector =
    buildMypyBoto3Package "inspector" "1.44.0"
      "sha256-vb/GJXHTedWJecZWILJzAObi5GCpLRnSuu0MmQcx51o=";

  mypy-boto3-inspector2 =
    buildMypyBoto3Package "inspector2" "1.44.0"
      "sha256-LKf5+ZKnDKrCvQf/2x4y8BlOdB4EN364yTcLQCAyH5A=";

  mypy-boto3-internetmonitor =
    buildMypyBoto3Package "internetmonitor" "1.44.0"
      "sha256-dZdl4fR5wOAfsF66ckTid2OAYci9PtgLIhVwUKESK14=";

  mypy-boto3-iot =
    buildMypyBoto3Package "iot" "1.44.0"
      "sha256-aYobupi/fVHCqe40ukUzjTcut92Bp0L+FpmUEQvfBgo=";

  mypy-boto3-iot-data =
    buildMypyBoto3Package "iot-data" "1.44.0"
      "sha256-CcEjMJaou/oeTt7CyLb4FlwJP+qfpd1NLO1Vt/ahXvo=";

  mypy-boto3-iot-jobs-data =
    buildMypyBoto3Package "iot-jobs-data" "1.44.0"
      "sha256-vj5zonRPguSbUI3oVcdqM53CyePVNGpT4KHi1p1cBJ0=";

  mypy-boto3-iot1click-devices =
    buildMypyBoto3Package "iot1click-devices" "1.35.93"
      "sha256-fwfuhSitYIJW5QswYdZ8ZpNL3AEg6MXhJitbbU48STs=";

  mypy-boto3-iot1click-projects =
    buildMypyBoto3Package "iot1click-projects" "1.35.93"
      "sha256-LFuz5/nCZGpSfgqyswxn80VzxXsqzZlBFqPtPJ8bzgo=";

  mypy-boto3-iotanalytics =
    buildMypyBoto3Package "iotanalytics" "1.42.3"
      "sha256-KnsQjmsXPq1VOsgdfPQ8NpXbXJ3ed3nQ6u4xd5SvGHI=";

  mypy-boto3-iotdeviceadvisor =
    buildMypyBoto3Package "iotdeviceadvisor" "1.44.0"
      "sha256-2vGcGCVVu8lDy0aTF2UPiv4DDOw6WyvWjha/evNFQ5M=";

  mypy-boto3-iotevents =
    buildMypyBoto3Package "iotevents" "1.43.0"
      "sha256-vrbVRBb2BCGTG+0hth2BQVmF62R/ufvrXHYfl2L9R/w=";

  mypy-boto3-iotevents-data =
    buildMypyBoto3Package "iotevents-data" "1.43.0"
      "sha256-UMcPVbdXrdQ0MApotjGVJTMhJABvM5sOU9liZSZJWBs=";

  mypy-boto3-iotfleethub =
    buildMypyBoto3Package "iotfleethub" "1.40.17"
      "sha256-SeJi6Z/TJAiqL6+21CMP6iZF/Skv1hnmldPrJpOHUfo=";

  mypy-boto3-iotfleetwise =
    buildMypyBoto3Package "iotfleetwise" "1.44.0"
      "sha256-PAuElrrnr4Lw/lP4BPwbHlEbJ2vbiys82wpzo/FskSU=";

  mypy-boto3-iotsecuretunneling =
    buildMypyBoto3Package "iotsecuretunneling" "1.44.0"
      "sha256-uK54/ED/f+CGQkBSAlesSVsPHfKjTjmYtVSF1eEK4lU=";

  mypy-boto3-iotsitewise =
    buildMypyBoto3Package "iotsitewise" "1.44.0"
      "sha256-RGuzTArAl0bILr5L8Szwt38Co9FPVl7z4cXiCIbXPrU=";

  mypy-boto3-iotthingsgraph =
    buildMypyBoto3Package "iotthingsgraph" "1.44.0"
      "sha256-qk7Okb8ENeJwDAqg3aFoS8RrI8UNPmcqYAxhHZnxO00=";

  mypy-boto3-iottwinmaker =
    buildMypyBoto3Package "iottwinmaker" "1.44.0"
      "sha256-7THMoXcSdmoCWLW1cVCBCi59k/la8NhsCTvCpaPDaPM=";

  mypy-boto3-iotwireless =
    buildMypyBoto3Package "iotwireless" "1.44.0"
      "sha256-5z0GWM0k3bBKTag312rNkOp1rbfsRV/Ss4C9pC9sRMA=";

  mypy-boto3-ivs =
    buildMypyBoto3Package "ivs" "1.44.0"
      "sha256-QCz9pT5pRK/+J01m6z+1vIyOe/zpM4Ud9gxIjjkE6Ys=";

  mypy-boto3-ivs-realtime =
    buildMypyBoto3Package "ivs-realtime" "1.44.0"
      "sha256-yfd/Mmp1bfz4jkKkPinEYdYb+04yYdpOWyJhC6uIgFA=";

  mypy-boto3-ivschat =
    buildMypyBoto3Package "ivschat" "1.44.0"
      "sha256-6ag+JfOaAgM3vDbulu/Hi/znT66v5wZUzdO6BP7Up6U=";

  mypy-boto3-kafka =
    buildMypyBoto3Package "kafka" "1.44.0"
      "sha256-ZxYHL5Icvpm3AjT6MjYeI26Dg2p9rj8z1u/Nd1Vw2i8=";

  mypy-boto3-kafkaconnect =
    buildMypyBoto3Package "kafkaconnect" "1.44.0"
      "sha256-q+Tnmh/V17hFstRU4hdifr+C7uklapCndCqkJhFiBOQ=";

  mypy-boto3-kendra =
    buildMypyBoto3Package "kendra" "1.44.0"
      "sha256-N8hZHgnn/dzQECcZpMiX/LvSKHo5XA6k8Yh/dwDiAtY=";

  mypy-boto3-kendra-ranking =
    buildMypyBoto3Package "kendra-ranking" "1.44.0"
      "sha256-TmOFmaP2IL92P+YDcxOErHWYQ3kmoDM8Wsi/iqQP4z4=";

  mypy-boto3-keyspaces =
    buildMypyBoto3Package "keyspaces" "1.44.0"
      "sha256-ELKk5u6tkz7+/e3/0JvTxEEMKNMXuKGXe7CS60K4AO0=";

  mypy-boto3-kinesis =
    buildMypyBoto3Package "kinesis" "1.44.0"
      "sha256-rFSSZ/f3QVVm3IiOEDi/lyRH1Q519BGWZyayX6Dc2OM=";

  mypy-boto3-kinesis-video-archived-media =
    buildMypyBoto3Package "kinesis-video-archived-media" "1.44.0"
      "sha256-piypzNdjJrLVU6vc5TvaDuIEPCFHUxjhppvbrA7ZP/8=";

  mypy-boto3-kinesis-video-media =
    buildMypyBoto3Package "kinesis-video-media" "1.44.0"
      "sha256-AR5sGrTkoe/dj5ImQVDwtRIy05R+J9oeeUij2DPeN8c=";

  mypy-boto3-kinesis-video-signaling =
    buildMypyBoto3Package "kinesis-video-signaling" "1.44.0"
      "sha256-SOP52gZ+NFqQ6f7ONcUDcrtPS4IxN2V6v4mn7n4a2EA=";

  mypy-boto3-kinesis-video-webrtc-storage =
    buildMypyBoto3Package "kinesis-video-webrtc-storage" "1.44.0"
      "sha256-rzGwp49Q+H1KU7AW2LYYx1vNq0CGwwDhRUNh1H6KvLY=";

  mypy-boto3-kinesisanalytics =
    buildMypyBoto3Package "kinesisanalytics" "1.44.0"
      "sha256-Na0HmksUOCYCQ/IKmJuaRLUbNbvvTNec4LF4jQZUYhE=";

  mypy-boto3-kinesisanalyticsv2 =
    buildMypyBoto3Package "kinesisanalyticsv2" "1.44.1"
      "sha256-SCRLYeT3YhurCijRY3yiHqiSK/OfIrPyC7ZB0FxBw0o=";

  mypy-boto3-kinesisvideo =
    buildMypyBoto3Package "kinesisvideo" "1.44.0"
      "sha256-eg+EoS4hWXHjCr0hgd4vIUeeITFhdY2y+d3DuqBvkKk=";

  mypy-boto3-kms =
    buildMypyBoto3Package "kms" "1.44.0"
      "sha256-TjEEHeXyYR11jZFvvhYNGFmsop1bXJZP4SNuQyEx1cY=";

  mypy-boto3-lakeformation =
    buildMypyBoto3Package "lakeformation" "1.44.0"
      "sha256-kE1xY1aY4Z1DKIV6qflz1Jl+P0oDSQTJReIKzq/+fus=";

  mypy-boto3-lambda =
    buildMypyBoto3Package "lambda" "1.44.0"
      "sha256-XvOvOQSW/3E5hRSt2wsdbDv+o3rkXIiE/KozOoVcdAk=";

  mypy-boto3-lex-models =
    buildMypyBoto3Package "lex-models" "1.44.0"
      "sha256-xg8W8eojoZAbMoiaC3dAacvUbreqbl9dOoJMv55LN3o=";

  mypy-boto3-lex-runtime =
    buildMypyBoto3Package "lex-runtime" "1.44.0"
      "sha256-MbMYBMhVkglu9zfZuyqsSYlUtlRs7OtGFrAACNKTg6M=";

  mypy-boto3-lexv2-models =
    buildMypyBoto3Package "lexv2-models" "1.44.0"
      "sha256-2PsxXVC59jvzMv4QZpc71ma56hmNO6OKfca+fbRCtvw=";

  mypy-boto3-lexv2-runtime =
    buildMypyBoto3Package "lexv2-runtime" "1.44.0"
      "sha256-cW6O7syuE5XqXQELXFeZrTA+onZE5HryYCPEHDGs6QE=";

  mypy-boto3-license-manager =
    buildMypyBoto3Package "license-manager" "1.44.0"
      "sha256-U15sCTUTJLenr4oj6xmFlR2eXd/JtdfamtxPyaXexFc=";

  mypy-boto3-license-manager-linux-subscriptions =
    buildMypyBoto3Package "license-manager-linux-subscriptions" "1.44.0"
      "sha256-2+bZjjiR6mRUVaXAFWiD2axmdfvccqwwwjX5gOhMe14=";

  mypy-boto3-license-manager-user-subscriptions =
    buildMypyBoto3Package "license-manager-user-subscriptions" "1.44.0"
      "sha256-I7d4pAN6Ce7w/+F2l7QiD6CXHJOv/HsasbqkoRXDIag=";

  mypy-boto3-lightsail =
    buildMypyBoto3Package "lightsail" "1.44.0"
      "sha256-eVFauEEWMPDC9ufdBW4GqLF/wsMxMkPGhaw+wgmRI/g=";

  mypy-boto3-location =
    buildMypyBoto3Package "location" "1.44.0"
      "sha256-fmZ96jqRxyfNocXEqhgKW3yMsdRTPtfDFvvP9c87Fqw=";

  mypy-boto3-logs =
    buildMypyBoto3Package "logs" "1.44.0"
      "sha256-5xN+YHkIhPyGZb/8s3AiowUeCKArkOoXx4ay0l+8rPM=";

  mypy-boto3-lookoutequipment =
    buildMypyBoto3Package "lookoutequipment" "1.44.0"
      "sha256-n+0NkWIZZEajJi5JfNQpkfQrhNClQNeL6jh2+r6c+lc=";

  mypy-boto3-lookoutmetrics =
    buildMypyBoto3Package "lookoutmetrics" "1.40.15"
      "sha256-ZcL1sZGlckqZFhCqTZwMeghP8K9Hee1Zi3N6wZb9hts=";

  mypy-boto3-lookoutvision =
    buildMypyBoto3Package "lookoutvision" "1.40.59"
      "sha256-MlMkIgzc2D3i5xAPdk+th0e9AYrvRxGwzl4zwEwy4xw=";

  mypy-boto3-m2 =
    buildMypyBoto3Package "m2" "1.44.0"
      "sha256-D3sjaacPqIIcsch3C3m5qq0l3ebjDTPM/8AHtHDfNJA=";

  mypy-boto3-machinelearning =
    buildMypyBoto3Package "machinelearning" "1.44.0"
      "sha256-vgNABa72k+btSsXHW7gHPkIBTI2O4QHQfhK/VkQDxa8=";

  mypy-boto3-macie2 =
    buildMypyBoto3Package "macie2" "1.44.0"
      "sha256-J2p2uFzOJXZuuZaKNMWzYW/zdx/VvxQj81cUxS1wTPU=";

  mypy-boto3-managedblockchain =
    buildMypyBoto3Package "managedblockchain" "1.44.0"
      "sha256-cMZuBKgQnenLH37cePepmUz0ro+HVFKhBzyP8+pZaE8=";

  mypy-boto3-managedblockchain-query =
    buildMypyBoto3Package "managedblockchain-query" "1.44.0"
      "sha256-3JN60coiVuF9QxziPv4QpSGpPCvZywiP6TnL1ent6BI=";

  mypy-boto3-marketplace-catalog =
    buildMypyBoto3Package "marketplace-catalog" "1.44.0"
      "sha256-NmSJDiccNcTY1OXin9aoDVa8eOTi9u8ix9njQ84gP2U=";

  mypy-boto3-marketplace-entitlement =
    buildMypyBoto3Package "marketplace-entitlement" "1.44.0"
      "sha256-oarxUfqQ2tX1f1Flwulmv0rS6eb1lBXEGGosjeNBEdc=";

  mypy-boto3-marketplacecommerceanalytics =
    buildMypyBoto3Package "marketplacecommerceanalytics" "1.44.0"
      "sha256-F+54zpdHA+W1AEJ1ELyWj/xSMhPovnCu9827dKiA0eI=";

  mypy-boto3-mediaconnect =
    buildMypyBoto3Package "mediaconnect" "1.44.0"
      "sha256-Mm1yGp296HiUnLF/rNmjUPlFCeG8YbGBGiGnbYjNL9A=";

  mypy-boto3-mediaconvert =
    buildMypyBoto3Package "mediaconvert" "1.44.0"
      "sha256-yMa8byNDmZ4R7C53s+8tEYIutxQkcSfVsQRS/W96JK0=";

  mypy-boto3-medialive =
    buildMypyBoto3Package "medialive" "1.44.0"
      "sha256-XAquR86JNqWGAleEXrbYULnCxrnh+ERHTDxafRlOlkg=";

  mypy-boto3-mediapackage =
    buildMypyBoto3Package "mediapackage" "1.44.0"
      "sha256-Mf1F2LML59/LVQugo+S2QvxWW576CBA1AiLHaKn9rOI=";

  mypy-boto3-mediapackage-vod =
    buildMypyBoto3Package "mediapackage-vod" "1.44.0"
      "sha256-8pZKrIXovGCm5RWGN1mc5SSlzrKIXDjXayF/nhalNU0=";

  mypy-boto3-mediapackagev2 =
    buildMypyBoto3Package "mediapackagev2" "1.44.1"
      "sha256-2tfCwiMV7o+TlUAZBgINKbb7KRIlAqNr9wBiuCPHpIs=";

  mypy-boto3-mediastore =
    buildMypyBoto3Package "mediastore" "1.44.0"
      "sha256-YLahAqWO+BBIIsen4Lx1kV8ptV5MIbmGfB0VhdzU3fw=";

  mypy-boto3-mediastore-data =
    buildMypyBoto3Package "mediastore-data" "1.44.0"
      "sha256-a4BR8AK7ZnI1EOtu2Jstq+53e7z+LvYb5oJRQfV2mqQ=";

  mypy-boto3-mediatailor =
    buildMypyBoto3Package "mediatailor" "1.44.0"
      "sha256-pFEkOxw4TMi1HgbWgpH2oD1Sm/LPfviJyWjYXh7hobs=";

  mypy-boto3-medical-imaging =
    buildMypyBoto3Package "medical-imaging" "1.44.0"
      "sha256-kfGcRhjZVxI+uzANt80hKJS3fWJ0wLzIq4GYCLO2t0M=";

  mypy-boto3-memorydb =
    buildMypyBoto3Package "memorydb" "1.44.1"
      "sha256-35zwDsaWDulMprb0zLlLV40J1cuyPvORKKzim7LvoS4=";

  mypy-boto3-meteringmarketplace =
    buildMypyBoto3Package "meteringmarketplace" "1.44.1"
      "sha256-PrHZDgolGUCtauZ4Xm9ldGs/d8kglHd2AKuKk0vaR58=";

  mypy-boto3-mgh =
    buildMypyBoto3Package "mgh" "1.44.0"
      "sha256-2zp2/RULK6mjOSyjmDinxsmKCDCS4tb0lOoMHWwXp24=";

  mypy-boto3-mgn =
    buildMypyBoto3Package "mgn" "1.44.0"
      "sha256-v5q/ekZpdBKs9XZijvMmM8tCeVIDlYPCwAim19nTh3I=";

  mypy-boto3-migration-hub-refactor-spaces =
    buildMypyBoto3Package "migration-hub-refactor-spaces" "1.44.0"
      "sha256-J+d31v2fCeFkv/dMicExLzbO1D4/MEQIrr432F5/Ctk=";

  mypy-boto3-migrationhub-config =
    buildMypyBoto3Package "migrationhub-config" "1.44.0"
      "sha256-QVqFyXpu/7i0G83PRqyLtRkFJDBclUXztS1PTJ4DfKA=";

  mypy-boto3-migrationhuborchestrator =
    buildMypyBoto3Package "migrationhuborchestrator" "1.44.0"
      "sha256-MCqPwESOVw1CaeRWe1VCSgLJw2+tThpQ/Apkx82wg+g=";

  mypy-boto3-migrationhubstrategy =
    buildMypyBoto3Package "migrationhubstrategy" "1.44.0"
      "sha256-167YFDBB5nk/KTchzlHKVI0Pgcw3hwV6KKAjSR37Loo=";

  mypy-boto3-mq =
    buildMypyBoto3Package "mq" "1.44.0"
      "sha256-xiZhNhNiBL9pqlWOKg1Ic8yJPa5x5Spp8yIGW5nisYM=";

  mypy-boto3-mturk =
    buildMypyBoto3Package "mturk" "1.44.0"
      "sha256-yGncINh1dG9U+GOxCc45AF567f9WXyle23k7tCeTUBk=";

  mypy-boto3-mwaa =
    buildMypyBoto3Package "mwaa" "1.44.0"
      "sha256-4nW7HUqK4BZOijoUWHC+W2X/DTpRfh6Ojh/k9hqRE0g=";

  mypy-boto3-neptune =
    buildMypyBoto3Package "neptune" "1.44.0"
      "sha256-IfWfeGzVJrmEl2hF5vy9ZThiStDVh2hGJ+LuQR6KWnY=";

  mypy-boto3-neptunedata =
    buildMypyBoto3Package "neptunedata" "1.44.0"
      "sha256-Fl5yORK+/l0l+HLf9QhTCAEVvfCMiNcvXpEXQzgsCvU=";

  mypy-boto3-network-firewall =
    buildMypyBoto3Package "network-firewall" "1.44.1"
      "sha256-kutXvT3hd9eFS2faX81eGgTdgBK1Hrk+KhFDGRB+2us=";

  mypy-boto3-networkmanager =
    buildMypyBoto3Package "networkmanager" "1.44.0"
      "sha256-TrbfhMkJoy+w/hqwhh0MugnjiDbQjpeNmYrgjsUguJc=";

  mypy-boto3-nimble =
    buildMypyBoto3Package "nimble" "1.35.0"
      "sha256-gs9eGyRaZN7Fsl0D5fSqtTiYZ+Exp0s8QW/X8ZR7guA=";

  mypy-boto3-oam =
    buildMypyBoto3Package "oam" "1.44.0"
      "sha256-ROzgOlpPC8J/c/LB+KX8K51ejz+llRXupUVeIHm+iaQ=";

  mypy-boto3-omics =
    buildMypyBoto3Package "omics" "1.44.0"
      "sha256-EbyFS/XisPA0U8v/QAsviOHnXYT6R0zn4MOLWajsJDo=";

  mypy-boto3-opensearch =
    buildMypyBoto3Package "opensearch" "1.44.0"
      "sha256-1uFCXVFQsRWvR/RxRAdcFTnpY7UteriX8LzrDjrowes=";

  mypy-boto3-opensearchserverless =
    buildMypyBoto3Package "opensearchserverless" "1.44.0"
      "sha256-83IXUctmLP4j/O9Sb14JkNJkFWfo2j1sj58J+C0a4AQ=";

  mypy-boto3-opsworks =
    buildMypyBoto3Package "opsworks" "1.40.0"
      "sha256-ZuSVlDalSjVyMGVem02HklbAmDZXJeWnd2GBrMFJKHU=";

  mypy-boto3-opsworkscm =
    buildMypyBoto3Package "opsworkscm" "1.40.0"
      "sha256-JEuEjo0htTuDCZx2nNJK2Zq59oSUqkMf4BrNamerfVk=";

  mypy-boto3-organizations =
    buildMypyBoto3Package "organizations" "1.44.0"
      "sha256-HpfNmKcWEbCAyWexRaY3Kcs6LLHyahEwW42N9TJWABE=";

  mypy-boto3-osis =
    buildMypyBoto3Package "osis" "1.44.0"
      "sha256-9tIYohGFx6ga+HDwkzIGHnswdIKVUDet406ZRXa+NEQ=";

  mypy-boto3-outposts =
    buildMypyBoto3Package "outposts" "1.44.0"
      "sha256-cb0djtWxA+bt/QP3h35IWnngVkJpKvD9DEn/8E41Og8=";

  mypy-boto3-panorama =
    buildMypyBoto3Package "panorama" "1.43.0"
      "sha256-DDNWvmo+i3O3s8sL16zg+QhWYzfrSTPOBHni8PVOgbs=";

  mypy-boto3-payment-cryptography =
    buildMypyBoto3Package "payment-cryptography" "1.44.0"
      "sha256-bAgq4IG3zRyi7qxm7trhF8CIecGRzOdji3Mw4o6dKJo=";

  mypy-boto3-payment-cryptography-data =
    buildMypyBoto3Package "payment-cryptography-data" "1.44.0"
      "sha256-2WSVlCn1MMY6ISe5WRyc4Pi9I/i0LgfriADISbtXGOA=";

  mypy-boto3-pca-connector-ad =
    buildMypyBoto3Package "pca-connector-ad" "1.44.0"
      "sha256-tF8hJ/SRQxdpW9UdaSzzHW71FOUb+t9sQzFpFLfk/wY=";

  mypy-boto3-personalize =
    buildMypyBoto3Package "personalize" "1.44.0"
      "sha256-R+YMQPX3loaywK/8k/o2Ej6DvyTz7Jr9itOQ6tW+KJc=";

  mypy-boto3-personalize-events =
    buildMypyBoto3Package "personalize-events" "1.44.0"
      "sha256-9GvYVFVHPxLog/cjvBtj7iPTJ3kw5/iJnN4Ln6inT0w=";

  mypy-boto3-personalize-runtime =
    buildMypyBoto3Package "personalize-runtime" "1.44.0"
      "sha256-wIKJmD9gEwpPE8vz8PQE1JrbFTfHGeLPzoSw3Syb0Is=";

  mypy-boto3-pi =
    buildMypyBoto3Package "pi" "1.44.0"
      "sha256-JuShyuQRj/2ujgrctg2CJud7eYQj60/UIltLa6OGdiU=";

  mypy-boto3-pinpoint =
    buildMypyBoto3Package "pinpoint" "1.44.0"
      "sha256-h09cRhVQ5mrzIV9VhJJJbnh6x/mIySzTSvBIFxmIJ38=";

  mypy-boto3-pinpoint-email =
    buildMypyBoto3Package "pinpoint-email" "1.44.0"
      "sha256-cNTNVboRCItLxLA4eUfkt6KhTLST9kAtAtMPccdp/O0=";

  mypy-boto3-pinpoint-sms-voice =
    buildMypyBoto3Package "pinpoint-sms-voice" "1.44.0"
      "sha256-Vu/IVgLs/pvfiOhK/8hePGMfr4CvtiPvMtq630aNhaQ=";

  mypy-boto3-pinpoint-sms-voice-v2 =
    buildMypyBoto3Package "pinpoint-sms-voice-v2" "1.44.0"
      "sha256-16D1cdfWNDIDixrfz1y8YD7ENbi2yHyBOSPaGZMwz5o=";

  mypy-boto3-pipes =
    buildMypyBoto3Package "pipes" "1.44.0"
      "sha256-wasYqLDwzNO40YGICPaSr+J4cHgdLv52VUIG2PoNK5s=";

  mypy-boto3-polly =
    buildMypyBoto3Package "polly" "1.44.0"
      "sha256-snR9LW0kOUCUUN0of3h+iifk2SxC86V0hUqQORC5Sng=";

  mypy-boto3-pricing =
    buildMypyBoto3Package "pricing" "1.44.0"
      "sha256-AihJF9HdFYorZ9tyi1QofwSw2SXRpguw7pQ3x4Oa2D0=";

  mypy-boto3-privatenetworks =
    buildMypyBoto3Package "privatenetworks" "1.38.0"
      "sha256-T04icQC+XwQZhaAEBWRiqfCUaayXP1szpbLdAG/7t3k=";

  mypy-boto3-proton =
    buildMypyBoto3Package "proton" "1.44.0"
      "sha256-5PW/aeG6NvAsuqG3/EPyMVZQJgmADpuzBuWEHxWGxr0=";

  mypy-boto3-qldb =
    buildMypyBoto3Package "qldb" "1.40.54"
      "sha256-7h7WswVMGPBf6WsX04+TXA3o8scarCUqnSW3dgUyadw=";

  mypy-boto3-qldb-session =
    buildMypyBoto3Package "qldb-session" "1.40.54"
      "sha256-YrrEKl3aGz//5Z5JGapHhWtk6hBXQ4cuRQmLqGYztzg=";

  mypy-boto3-quicksight =
    buildMypyBoto3Package "quicksight" "1.44.0"
      "sha256-geChnE8/P+F/j8D87Nh/jC53FxparC4IqW596Y+OnsI=";

  mypy-boto3-ram =
    buildMypyBoto3Package "ram" "1.44.0"
      "sha256-a2GDP9r11XNaZDI06mEedptMt3WZHS9BIn1rozbl7tk=";

  mypy-boto3-rbin =
    buildMypyBoto3Package "rbin" "1.44.0"
      "sha256-yAT9fUuhMoLJCmdK+7dsOcSwSwhgxiGsMhRNL+SqL7Q=";

  mypy-boto3-rds =
    buildMypyBoto3Package "rds" "1.44.0"
      "sha256-A2klNtAzB+7keN8A71dUdj/ykBm3Na0OFQzw8gnOUp0=";

  mypy-boto3-rds-data =
    buildMypyBoto3Package "rds-data" "1.44.0"
      "sha256-qUfsYDlgUfeIUEz0lhe2HLfbzRBT2aJY1wim+Y7qkp4=";

  mypy-boto3-redshift =
    buildMypyBoto3Package "redshift" "1.44.0"
      "sha256-6EOx0dk4YOiEqNzd2huvWGdL4JeFyiBetDnlvRzvxbw=";

  mypy-boto3-redshift-data =
    buildMypyBoto3Package "redshift-data" "1.44.0"
      "sha256-Xv2IMNTewEKU+ORort8seIq9iaN1rGvoaRhWPEo34u0=";

  mypy-boto3-redshift-serverless =
    buildMypyBoto3Package "redshift-serverless" "1.44.0"
      "sha256-uaz71iq4j12wSYv3SFXvwfduypcndqeFJmDGhdp3hc4=";

  mypy-boto3-rekognition =
    buildMypyBoto3Package "rekognition" "1.44.0"
      "sha256-Ghd1zuPrGz9m0A1ECUl0L8NmCsn8zlncD+9/6znvXrU=";

  mypy-boto3-resiliencehub =
    buildMypyBoto3Package "resiliencehub" "1.44.0"
      "sha256-itZ7JyyJRrntQxkgyrOmEKXQ8NFAcT1HERLGFSGD/9o=";

  mypy-boto3-resource-explorer-2 =
    buildMypyBoto3Package "resource-explorer-2" "1.44.0"
      "sha256-63sKzonJHlzbXzN8aDDCwmTDyy98BEaMuubR6J2axoE=";

  mypy-boto3-resource-groups =
    buildMypyBoto3Package "resource-groups" "1.44.0"
      "sha256-5HKbZ8DTWQud1bgm+xBz6g8KRDyAMd3DASIk6pJIw2U=";

  mypy-boto3-resourcegroupstaggingapi =
    buildMypyBoto3Package "resourcegroupstaggingapi" "1.44.1"
      "sha256-WwBeRP6ZxmtlN1aYSB0kBRhydyIdZji7K7BPldoDQjM=";

  mypy-boto3-robomaker =
    buildMypyBoto3Package "robomaker" "1.40.59"
      "sha256-jYAsZ1lMU9cl4rIvRO1UZLn4nIsuauWrNRwyB0j4HK0=";

  mypy-boto3-rolesanywhere =
    buildMypyBoto3Package "rolesanywhere" "1.44.0"
      "sha256-ix5rfd4ctTpet5Dnak4e3upJgNo0/lS4aHK4/ZpKHjo=";

  mypy-boto3-route53 =
    buildMypyBoto3Package "route53" "1.44.0"
      "sha256-4X0LZ5ogGmwoeiaEb4M356Xh89nDi17K8J1st253jLY=";

  mypy-boto3-route53-recovery-cluster =
    buildMypyBoto3Package "route53-recovery-cluster" "1.44.0"
      "sha256-F+mwCnhSSy1LzPeSpRWqzLdNg8PHnOat4j2JFf9QcEs=";

  mypy-boto3-route53-recovery-control-config =
    buildMypyBoto3Package "route53-recovery-control-config" "1.44.0"
      "sha256-drv+Cf8bEUNp6R6SC9nkxAFm4+bDTPU5jeXb9IUeYeo=";

  mypy-boto3-route53-recovery-readiness =
    buildMypyBoto3Package "route53-recovery-readiness" "1.44.0"
      "sha256-iSP43j/wsq3wAACTK6FjGGbwcFFA3tepNFHmkWVN13k=";

  mypy-boto3-route53domains =
    buildMypyBoto3Package "route53domains" "1.44.1"
      "sha256-tFeCRnPA04a/tvrOuS+lbFZOCbNlqN49Z+YpnhBtsCc=";

  mypy-boto3-route53resolver =
    buildMypyBoto3Package "route53resolver" "1.44.0"
      "sha256-FJhdetbWUDYFKIw6i3OvMGDc+iRS20SqxUDTB6zhX4E=";

  mypy-boto3-rum =
    buildMypyBoto3Package "rum" "1.44.0"
      "sha256-b1sDfF6Ht6a/zAD99SizLBrOLFamW5RwyU8eqbs6v/U=";

  mypy-boto3-s3 =
    buildMypyBoto3Package "s3" "1.44.0"
      "sha256-7Zjwxqvq27NqltomGcj2jyEvZnFlje/dPrgMAYxxedo=";

  mypy-boto3-s3control =
    buildMypyBoto3Package "s3control" "1.44.0"
      "sha256-QS+DHp0zS69sQ71IrXeUVtXLq6e/3WbuNW07F3wUBZY=";

  mypy-boto3-s3outposts =
    buildMypyBoto3Package "s3outposts" "1.44.0"
      "sha256-K1NDjbl3sfaZA+x8upUQkEfojgK0Ig556B+Ixo7wYjQ=";

  mypy-boto3-sagemaker =
    buildMypyBoto3Package "sagemaker" "1.44.0"
      "sha256-KQ+pq4Kp8F/N7dAWC6j5sihcJF0ZGazEuwXHIKa2K+g=";

  mypy-boto3-sagemaker-a2i-runtime =
    buildMypyBoto3Package "sagemaker-a2i-runtime" "1.44.0"
      "sha256-Ify8T4aDHIPlSYp8DBlzXUsdyQLGtHwoJkU++asVnEM=";

  mypy-boto3-sagemaker-edge =
    buildMypyBoto3Package "sagemaker-edge" "1.44.0"
      "sha256-Qv/qJOrvcKCNV487qgQvtGi4BOsQTaozJSrP9uB1u6A=";

  mypy-boto3-sagemaker-featurestore-runtime =
    buildMypyBoto3Package "sagemaker-featurestore-runtime" "1.44.0"
      "sha256-c8AiNlZvHjOfJWiIFFjuzpF3N6U8KvSwA65PQtNxkJI=";

  mypy-boto3-sagemaker-geospatial =
    buildMypyBoto3Package "sagemaker-geospatial" "1.44.0"
      "sha256-5egMhMAQ0s3zQp9m945BdmccRoT9tlRLgDwo3KfbrYo=";

  mypy-boto3-sagemaker-metrics =
    buildMypyBoto3Package "sagemaker-metrics" "1.44.0"
      "sha256-5OwO1YA7HDouPW86uCn4JvcGynj2SofQPT/TmE1Wgfk=";

  mypy-boto3-sagemaker-runtime =
    buildMypyBoto3Package "sagemaker-runtime" "1.44.0"
      "sha256-2tM76OE9zR/lAaHQotkAtgnw3j1M5OjsMNrQnrBTytY=";

  mypy-boto3-savingsplans =
    buildMypyBoto3Package "savingsplans" "1.44.0"
      "sha256-AdAhkSxlJwkd5GQUVnqCe8i2jFn0oymhHdfU8fpP+54=";

  mypy-boto3-scheduler =
    buildMypyBoto3Package "scheduler" "1.44.0"
      "sha256-wbHkVOfcuWl+Pz7SqcZu9fjtInRvdVCIx7ReeA8Hz74=";

  mypy-boto3-schemas =
    buildMypyBoto3Package "schemas" "1.44.0"
      "sha256-NhFbPjs1ybiUvdgOfr2mRNithDqYLD0RtbvhAFe0Plc=";

  mypy-boto3-sdb =
    buildMypyBoto3Package "sdb" "1.44.0"
      "sha256-4iBbL9h4cOuhRmjT01xE6+/AZ2k7a0Rm1a2GvYppi0k=";

  mypy-boto3-secretsmanager =
    buildMypyBoto3Package "secretsmanager" "1.44.0"
      "sha256-8YJB3c9xc7yc1cre93eJGEi4tBJymv1eTGgbT5jIiRU=";

  mypy-boto3-securityhub =
    buildMypyBoto3Package "securityhub" "1.44.0"
      "sha256-syvN/Nz92XKCFaD6+IxpiT+6kVso1UTpp6TKz+V27kU=";

  mypy-boto3-securitylake =
    buildMypyBoto3Package "securitylake" "1.44.0"
      "sha256-cjDmVi9WpprejbIxM2vY1TQZFpq+CawzbdaGgiBaog4=";

  mypy-boto3-serverlessrepo =
    buildMypyBoto3Package "serverlessrepo" "1.44.0"
      "sha256-fGXEebTfQLktgrRTkosXgyz7zLgZjJojBc4SZZRHYvw=";

  mypy-boto3-service-quotas =
    buildMypyBoto3Package "service-quotas" "1.44.0"
      "sha256-QaINChn9ThLO6FUVLGbQGH9PzzidvC1WzuyvJ4OrALk=";

  mypy-boto3-servicecatalog =
    buildMypyBoto3Package "servicecatalog" "1.44.1"
      "sha256-x7M/8Rx3c5JTRkuqLK6ZApc9HrK70kQUgMFG7V8fte0=";

  mypy-boto3-servicecatalog-appregistry =
    buildMypyBoto3Package "servicecatalog-appregistry" "1.44.0"
      "sha256-/RCGTe+L91TZLpUUWCRkZR1McCv7hGkvx/j9UJ5LUa0=";

  mypy-boto3-servicediscovery =
    buildMypyBoto3Package "servicediscovery" "1.44.1"
      "sha256-Pwe2Sc6/pJJridnrsqZQ/sSkadfjNdakTYgFSzo6vF0=";

  mypy-boto3-ses =
    buildMypyBoto3Package "ses" "1.44.0"
      "sha256-2FLaNkeV7GzVh9cV/kwhpb668Cxg49Gk5pqt1XT5lg8=";

  mypy-boto3-sesv2 =
    buildMypyBoto3Package "sesv2" "1.44.0"
      "sha256-YMIFaQlwLFdhp0iTzbNl5th4G3Yk0Mr4YGSknmkYiP0=";

  mypy-boto3-shield =
    buildMypyBoto3Package "shield" "1.44.1"
      "sha256-pHFTBer2vMktQFrSw7i16l3nDFmF1YqXvACWHklwbms=";

  mypy-boto3-signer =
    buildMypyBoto3Package "signer" "1.44.0"
      "sha256-DvbNsJkiMKCRh0kwdOi28aPy4V0o0NsKxYQhtvjPfLo=";

  mypy-boto3-simspaceweaver =
    buildMypyBoto3Package "simspaceweaver" "1.43.0"
      "sha256-Uh/EREUJuFFWw3ObXhDSWgU8DXRi2znVgfWhMhnhE0s=";

  mypy-boto3-sms =
    buildMypyBoto3Package "sms" "1.40.0"
      "sha256-ZVrH3luEpHwORa+1LNdmgju3+JUy9/F6ghNzHZUicBc=";

  mypy-boto3-sms-voice =
    buildMypyBoto3Package "sms-voice" "1.38.0"
      "sha256-qWnTJxM1h3pmY2PnI8PjT7u4+xODrSQM41IK8QsJCfM=";

  mypy-boto3-snow-device-management =
    buildMypyBoto3Package "snow-device-management" "1.44.0"
      "sha256-hz/KFuHVnxuhkLxV6R5LL7ZXwsJ3rIxFeyPuaXBPHnw=";

  mypy-boto3-snowball =
    buildMypyBoto3Package "snowball" "1.44.0"
      "sha256-pJ/kSpmXoUFaSa5ltNkn0/P+bN/XH4oRNECmSAYS1xE=";

  mypy-boto3-sns =
    buildMypyBoto3Package "sns" "1.44.0"
      "sha256-hzeht+fMjfGfL2FiktLnyEkt3Xg+eKoqf4hHtjjy5L0=";

  mypy-boto3-sqs =
    buildMypyBoto3Package "sqs" "1.44.0"
      "sha256-giX/90bJ5p5QZ9OqnxkYtq3gfl2p6sX3fz+POPtbuWk=";

  mypy-boto3-ssm =
    buildMypyBoto3Package "ssm" "1.44.0"
      "sha256-zZuaNs3ywsAvct8+xChjb0g9SBlXVp18dDO/Ky5FvMI=";

  mypy-boto3-ssm-contacts =
    buildMypyBoto3Package "ssm-contacts" "1.44.0"
      "sha256-PoZ4BDgYyQYRJh8nR+TdA0UwdsxUrgaC+3eGu2SgO1Q=";

  mypy-boto3-ssm-incidents =
    buildMypyBoto3Package "ssm-incidents" "1.44.0"
      "sha256-cZ0gzfVGrc55aUPkOf/6yDrTHNuYsn2z7mQSAYIJooo=";

  mypy-boto3-ssm-sap =
    buildMypyBoto3Package "ssm-sap" "1.44.0"
      "sha256-QP2VkCplUljLAx0zqMml5IN+CH908t4P7vyPsh0OA+o=";

  mypy-boto3-sso =
    buildMypyBoto3Package "sso" "1.44.0"
      "sha256-uZnkrFyjgx6yV9r/yM3+xvVS6lfku1WCSFR/TCMAFxI=";

  mypy-boto3-sso-admin =
    buildMypyBoto3Package "sso-admin" "1.44.0"
      "sha256-05Ju1bb0DDUEj3cPBUX93Te7Ev8nNQN1qtLZKgIX4IY=";

  mypy-boto3-sso-oidc =
    buildMypyBoto3Package "sso-oidc" "1.44.0"
      "sha256-5LLu+ptn6duAbMh+RD9yvoTdbsjwqV5m/UjfC5sR+ho=";

  mypy-boto3-stepfunctions =
    buildMypyBoto3Package "stepfunctions" "1.44.0"
      "sha256-NHuisoBr97bgHPpdco4A5M6vH0Rwi8J/IjJ2jROhpAI=";

  mypy-boto3-storagegateway =
    buildMypyBoto3Package "storagegateway" "1.44.0"
      "sha256-WlOyKZoXsncOjsoSVckNkR1xeRf0Ff7NiYYTpyCbs6E=";

  mypy-boto3-sts =
    buildMypyBoto3Package "sts" "1.44.0"
      "sha256-SChQDCx7LFXJwqpa0jmXQw2ySmwZpUjoCkIeLQUz9nw=";

  mypy-boto3-support =
    buildMypyBoto3Package "support" "1.44.0"
      "sha256-kEdFlcA5/gbc3Bw7/xcmRrUfJNbrIR0DY1XkHSjpjlo=";

  mypy-boto3-support-app =
    buildMypyBoto3Package "support-app" "1.44.0"
      "sha256-JKDdB5N6dJ/0jUjkptCQsYeS/Tm0CCHNvV6nTiG0zQ0=";

  mypy-boto3-swf =
    buildMypyBoto3Package "swf" "1.44.0"
      "sha256-8BtQvCnGdzy0LnA+Oj8DNCvAAFl4n15BLzXeLPyRXxA=";

  mypy-boto3-synthetics =
    buildMypyBoto3Package "synthetics" "1.44.0"
      "sha256-OYi225Nc686sUqw8BIF7f+tv6cBnYXfOi8PdYYhJDPo=";

  mypy-boto3-textract =
    buildMypyBoto3Package "textract" "1.44.0"
      "sha256-uod4pqsUtigaCHVec9pz2C7s/Y1GVSXz+6UTkRHlZA4=";

  mypy-boto3-timestream-query =
    buildMypyBoto3Package "timestream-query" "1.44.0"
      "sha256-zGiXoCbizIk2KyU0bnZOf8Kfkk9yb5MpmrsDiB2Ipcs=";

  mypy-boto3-timestream-write =
    buildMypyBoto3Package "timestream-write" "1.44.0"
      "sha256-bmibCFGJjSXeLDhguxLtdWSWUsW51OGUtkQW8V0aT0Q=";

  mypy-boto3-tnb =
    buildMypyBoto3Package "tnb" "1.43.0"
      "sha256-fc0e8DEx/b6M3kPB4Y07qqqMayg2BGSQ69gkuhcrl9Y=";

  mypy-boto3-transcribe =
    buildMypyBoto3Package "transcribe" "1.44.0"
      "sha256-EUu902pVyT0grvSK/5waG7Cvnwv3s/2m3Bk4PxGjW/s=";

  mypy-boto3-transfer =
    buildMypyBoto3Package "transfer" "1.44.0"
      "sha256-3oGRmtT7+YGFiWDzS4tKVS+sOhygszqyZ+84Mi8Ni3s=";

  mypy-boto3-translate =
    buildMypyBoto3Package "translate" "1.44.0"
      "sha256-rcRzEZEQQohSb2P15jKFxDCIUTt7MASv1PmKwQsN6t0=";

  mypy-boto3-verifiedpermissions =
    buildMypyBoto3Package "verifiedpermissions" "1.44.0"
      "sha256-yKshXFywurG0ju+fM8KLXilIxM9ATcJUTa/8Pujoc34=";

  mypy-boto3-voice-id =
    buildMypyBoto3Package "voice-id" "1.44.0"
      "sha256-Wru7Xj5yL74i6gcqXwpRbK1nPm1mN5UrH4Fe3yn7QzE=";

  mypy-boto3-vpc-lattice =
    buildMypyBoto3Package "vpc-lattice" "1.44.0"
      "sha256-aJ/59r81OyDJR2m+S1E/ykndBqcqQ9rmt8NWWzjjeKs=";

  mypy-boto3-waf =
    buildMypyBoto3Package "waf" "1.44.0"
      "sha256-eMDUErg4LYdN+FA6qgqJnVlDdPCY/EDebQmGpzK+Tng=";

  mypy-boto3-waf-regional =
    buildMypyBoto3Package "waf-regional" "1.44.0"
      "sha256-w9vJJlz7d/O/igNLx9lAb0uQBMxJaJt2Qq336nvfrBk=";

  mypy-boto3-wafv2 =
    buildMypyBoto3Package "wafv2" "1.44.0"
      "sha256-bkeQFHPnwDm8Mj3RG0JjsFQ9yJjvMSelVInHO09X9lo=";

  mypy-boto3-wellarchitected =
    buildMypyBoto3Package "wellarchitected" "1.44.0"
      "sha256-uqXHKiqN6TkvMc/Z8E8niRa9LhSeoUyk3BsAU7VwLU8=";

  mypy-boto3-wisdom =
    buildMypyBoto3Package "wisdom" "1.44.0"
      "sha256-zMcjT8VrOMKDG2UWOdCKmzJ3sxyII9EsK6JG6eaiNQQ=";

  mypy-boto3-workdocs =
    buildMypyBoto3Package "workdocs" "1.44.0"
      "sha256-jj7T8diuSbo3R+HiZL4MGNaeMT4z/Y9rjo8MdaBXW1U=";

  mypy-boto3-worklink =
    buildMypyBoto3Package "worklink" "1.35.0"
      "sha256-AgK4Xg1dloJmA+h4+mcBQQVTvYKjLCk5tPDbl/ItCVQ=";

  mypy-boto3-workmail =
    buildMypyBoto3Package "workmail" "1.44.0"
      "sha256-5dqAOl5R1D0d7GN1cMY1uHX22k/mPFIp4gVd4EVFGJw=";

  mypy-boto3-workmailmessageflow =
    buildMypyBoto3Package "workmailmessageflow" "1.44.0"
      "sha256-OmwRbATIB6dG3GsZRb3pMrcv2xXbcoxSLqFVXgRLoAc=";

  mypy-boto3-workspaces =
    buildMypyBoto3Package "workspaces" "1.44.0"
      "sha256-W6jjRSDs9ekFa0TzF8jw0qbQTfItQe84+FjL4RUGzr4=";

  mypy-boto3-workspaces-web =
    buildMypyBoto3Package "workspaces-web" "1.44.0"
      "sha256-I6vZwP2I0qYfbGtl4hs+qL9IK+bJsQokQIL+dtCb284=";

  mypy-boto3-xray =
    buildMypyBoto3Package "xray" "1.44.0"
      "sha256-JWMEd/9xNxYIrSWC8RRYlHDBhobKMuhVTDGlqJ7SP7w=";
}
