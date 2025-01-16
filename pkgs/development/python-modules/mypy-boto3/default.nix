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
    buildPythonPackage rec {
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
    buildMypyBoto3Package "accessanalyzer" "1.36.0"
      "sha256-n4KW1660NKsx+mhyctOZPf5xAy5GQTremzvJVVOI/EQ=";

  mypy-boto3-account =
    buildMypyBoto3Package "account" "1.36.0"
      "sha256-n0m7vTDElHau7LfFZEVvy0gyOPFmpG1RPVR4tmbnSuk=";

  mypy-boto3-acm =
    buildMypyBoto3Package "acm" "1.36.0"
      "sha256-YidmZX6XLk9a5oupICy7bzfzhyWWa4JAArDEXiMT3Us=";

  mypy-boto3-acm-pca =
    buildMypyBoto3Package "acm-pca" "1.36.0"
      "sha256-2LHrGmkx7GwtcsVNImY9e54f/AewDY0qdcMSd3ktDCE=";

  mypy-boto3-amp =
    buildMypyBoto3Package "amp" "1.36.0"
      "sha256-lBlnrl5KJ9LV036fl5tKq/UF1iRROVfO6NQryFc94e8=";

  mypy-boto3-amplify =
    buildMypyBoto3Package "amplify" "1.36.0"
      "sha256-mtmY1VpEEo3Nrcbjs7lO0YLsGxAEZ7gRn8MhJEUWQiU=";

  mypy-boto3-amplifybackend =
    buildMypyBoto3Package "amplifybackend" "1.36.0"
      "sha256-F5HP2gkW3++W/5n/74cjXD7GGYVbzII6sK3qN7ILSQM=";

  mypy-boto3-amplifyuibuilder =
    buildMypyBoto3Package "amplifyuibuilder" "1.36.0"
      "sha256-YHm++qKH+f84RMSHXVXC4uI/tB83V0qXp/dDU4E98RM=";

  mypy-boto3-apigateway =
    buildMypyBoto3Package "apigateway" "1.36.0"
      "sha256-tATJDIcqQCEbLFVUFvNhr59RtAFtpUUHF65YFB757tE=";

  mypy-boto3-apigatewaymanagementapi =
    buildMypyBoto3Package "apigatewaymanagementapi" "1.36.0"
      "sha256-wqul7cHa1ui2Wbyl01bnwZgIUZZodniAn6EQ24bgfkI=";

  mypy-boto3-apigatewayv2 =
    buildMypyBoto3Package "apigatewayv2" "1.36.0"
      "sha256-UDfSHfLkzNNcecERrGCJIYnVJE27qCECZ2CRmFxvGRM=";

  mypy-boto3-appconfig =
    buildMypyBoto3Package "appconfig" "1.36.0"
      "sha256-PzjL0tfTWdqI3Jlu7q+kwRdIR5CeMaMn3XcmPf39VCQ=";

  mypy-boto3-appconfigdata =
    buildMypyBoto3Package "appconfigdata" "1.36.0"
      "sha256-NDbRSYM+pptCYKDzUqrBkljUZ2x6IQh2JZBvfamGJMc=";

  mypy-boto3-appfabric =
    buildMypyBoto3Package "appfabric" "1.36.0"
      "sha256-jFxX1FwkOgs7SV8oyWyeVrLrn+SNa22czSojSFjRH58=";

  mypy-boto3-appflow =
    buildMypyBoto3Package "appflow" "1.36.0"
      "sha256-GWdN9gs0oBgYNfkp1z4FdyyLh4SBa7IyQG5vfFgeAKM=";

  mypy-boto3-appintegrations =
    buildMypyBoto3Package "appintegrations" "1.36.0"
      "sha256-fdz2ox0r3obpcvqRVtTj3ZF3VQJCQqW8KDbkPC2JUfM=";

  mypy-boto3-application-autoscaling =
    buildMypyBoto3Package "application-autoscaling" "1.36.0"
      "sha256-3NcyH5Z2NzGQuWgjk8ywSDLJEb/fiG5RyEpfAylKTAw=";

  mypy-boto3-application-insights =
    buildMypyBoto3Package "application-insights" "1.36.0"
      "sha256-VrkJZgxPjzKyTMCrinaDXTyJ5QH+80u28dThroi9lO0=";

  mypy-boto3-applicationcostprofiler =
    buildMypyBoto3Package "applicationcostprofiler" "1.36.0"
      "sha256-+vxUQh0KJPSV4prDxD0nl0DvqnNafSQqWibK0gpkwb0=";

  mypy-boto3-appmesh =
    buildMypyBoto3Package "appmesh" "1.36.0"
      "sha256-AOsNjW/35L/BEkM3mjcC6T+JBCaOs2BHeXm7qVaBu2Q=";

  mypy-boto3-apprunner =
    buildMypyBoto3Package "apprunner" "1.36.0"
      "sha256-yom2bJBipo+ywhlUjueeELrTV+cYW43zVbdKIYvjHGg=";

  mypy-boto3-appstream =
    buildMypyBoto3Package "appstream" "1.36.0"
      "sha256-mmoqRFyHOcY9oVufUP5t9OlhUVQt1Fu5zaIC6iLiBt8=";

  mypy-boto3-appsync =
    buildMypyBoto3Package "appsync" "1.36.0"
      "sha256-06PnQoBKYhqj97pumXoknt4QwWTmFZqdHw80WnMBad8=";

  mypy-boto3-arc-zonal-shift =
    buildMypyBoto3Package "arc-zonal-shift" "1.36.0"
      "sha256-wa6MOuI5e1EF5OiD+Sv1oji1UVN36sZZOX7mdLcnxUg=";

  mypy-boto3-athena =
    buildMypyBoto3Package "athena" "1.36.0"
      "sha256-DlOwJcQLN0zez/rf7sQrT+WAxRGwSNKsJvOIu8RhS6k=";

  mypy-boto3-auditmanager =
    buildMypyBoto3Package "auditmanager" "1.36.0"
      "sha256-14tXgIYjMC62ZDPhdU5FeaIYDRlIGkVtek33a8+JW8c=";

  mypy-boto3-autoscaling =
    buildMypyBoto3Package "autoscaling" "1.36.0"
      "sha256-5bglP1RyXt+S9uS9laiEEneLYR4mj1bMY3RcfYNEoz0=";

  mypy-boto3-autoscaling-plans =
    buildMypyBoto3Package "autoscaling-plans" "1.36.0"
      "sha256-DKQN+a0VCBBJWxSFq+3GwlSMIxmBfT6U71TCQdnItSs=";

  mypy-boto3-backup =
    buildMypyBoto3Package "backup" "1.36.0"
      "sha256-wf4co7MzwIJUsFCcctPUVUMDKHN8m9cr8RgjjWdGvxU=";

  mypy-boto3-backup-gateway =
    buildMypyBoto3Package "backup-gateway" "1.36.0"
      "sha256-mvC8pHHoNIK8xgiwGuoRcYsr1UkP57ZwQtuvRfYazk8=";

  mypy-boto3-batch =
    buildMypyBoto3Package "batch" "1.36.0"
      "sha256-xXgkkAmQUunyMexJHVMX9W2aqSXyE4BmN0w+4FKbM/Y=";

  mypy-boto3-billingconductor =
    buildMypyBoto3Package "billingconductor" "1.36.0"
      "sha256-3MHW/WRsrrK7AXZYHKocDUY3a4FvMKlCtbI05LJCjdA=";

  mypy-boto3-braket =
    buildMypyBoto3Package "braket" "1.36.0"
      "sha256-EBN9etCJnTpWBEJ07UKFvuQ05eYdM8beV8kq91uSuv8=";

  mypy-boto3-budgets =
    buildMypyBoto3Package "budgets" "1.36.0"
      "sha256-zheHmvv30hdyy91ZVJChfM0kHrGrI/fxyjN34PFnQ9E=";

  mypy-boto3-ce =
    buildMypyBoto3Package "ce" "1.36.0"
      "sha256-fbgvRVVApIbdcfbsKwZx7QgZboUTu5FYicVsC+vGrfg=";

  mypy-boto3-chime =
    buildMypyBoto3Package "chime" "1.36.0"
      "sha256-OpXjgK7npAG40XSjiViO5jhyaopLL/0XGLk8nBas4ss=";

  mypy-boto3-chime-sdk-identity =
    buildMypyBoto3Package "chime-sdk-identity" "1.36.0"
      "sha256-EbWMjDqXL8GFlzBU8I9gTGFqougB10Ht9HtMwpZoDbY=";

  mypy-boto3-chime-sdk-media-pipelines =
    buildMypyBoto3Package "chime-sdk-media-pipelines" "1.36.0"
      "sha256-a7AuD17NdZ+4yIKHP+Yh0Kez7Zl/H15rXR7MlUCluoM=";

  mypy-boto3-chime-sdk-meetings =
    buildMypyBoto3Package "chime-sdk-meetings" "1.36.0"
      "sha256-LDBl9lu8XAUxag4xeOHN440BVsj4H+QP7YMbMxrirBA=";

  mypy-boto3-chime-sdk-messaging =
    buildMypyBoto3Package "chime-sdk-messaging" "1.36.0"
      "sha256-uw6iyiw8oO8iJDgoEV8Ii9gCH1WTQOjvUafVTvA63RY=";

  mypy-boto3-chime-sdk-voice =
    buildMypyBoto3Package "chime-sdk-voice" "1.36.0"
      "sha256-FvcQXkciDqYfe2CrHBk7JiroKYhUlnt4jjI07M1kHJ0=";

  mypy-boto3-cleanrooms =
    buildMypyBoto3Package "cleanrooms" "1.36.0"
      "sha256-xkpS9vxlmqGTTJ9uWqIFM+phDlg3blPAR5FyWBdUPRw=";

  mypy-boto3-cloud9 =
    buildMypyBoto3Package "cloud9" "1.36.0"
      "sha256-yI4hvfNnHy8L/RVWKDzEQXAhZMjN2i5mN49AMk1NEFc=";

  mypy-boto3-cloudcontrol =
    buildMypyBoto3Package "cloudcontrol" "1.36.0"
      "sha256-QGlKR/jw8s/wmWnAMOFB1UMWAnw37ptEaZFBhuzDpXI=";

  mypy-boto3-clouddirectory =
    buildMypyBoto3Package "clouddirectory" "1.36.0"
      "sha256-NQnrx4nzScaOBOYsiN8UjOT3LXYrgC/MW4AIPBr1l0I=";

  mypy-boto3-cloudformation =
    buildMypyBoto3Package "cloudformation" "1.36.0"
      "sha256-rMLHrokg8RZ74Jf2FRaF/lrumb4viQB17fk+BdKY6LA=";

  mypy-boto3-cloudfront =
    buildMypyBoto3Package "cloudfront" "1.36.0"
      "sha256-6HRqoRpUsrvPVrNvVlQodzjWpfk5Eq472jCzNVMULzM=";

  mypy-boto3-cloudhsm =
    buildMypyBoto3Package "cloudhsm" "1.36.0"
      "sha256-2ZSO4xHkzT2FdTbmJM27su7W3pgeQeD+dlqfo38ZElQ=";

  mypy-boto3-cloudhsmv2 =
    buildMypyBoto3Package "cloudhsmv2" "1.36.0"
      "sha256-O1be9NIBrGOOK3K9c5+s9KbLXbw+l7uzqfO66GzwEK0=";

  mypy-boto3-cloudsearch =
    buildMypyBoto3Package "cloudsearch" "1.36.0"
      "sha256-V2kyXzNVy9i+WuYsEY9LIW+Eiy0Qby6j+051Xv7JuZo=";

  mypy-boto3-cloudsearchdomain =
    buildMypyBoto3Package "cloudsearchdomain" "1.36.0"
      "sha256-FCOuT2svx3aUPC0OEJE7yKDPjdATV3w1ILmZGgAOaXs=";

  mypy-boto3-cloudtrail =
    buildMypyBoto3Package "cloudtrail" "1.36.0"
      "sha256-ZPxfq5J7Vm/dGMAdyKiQskaJ3DyQcg/6DjsjxLqJx4Y=";

  mypy-boto3-cloudtrail-data =
    buildMypyBoto3Package "cloudtrail-data" "1.36.0"
      "sha256-zJ+t+f4qd7spaXtaQSzbXWozkLNQ8JgmVO6/ug5wI1I=";

  mypy-boto3-cloudwatch =
    buildMypyBoto3Package "cloudwatch" "1.36.0"
      "sha256-o3DWFSISGrRXxEPDOKZS0NPhwiEC2dufGX/V3LfmVqQ=";

  mypy-boto3-codeartifact =
    buildMypyBoto3Package "codeartifact" "1.36.0"
      "sha256-adJN1hy0NsAFWRgBuT7uOqlFWQtHasuHyC6TwQ/oE/8=";

  mypy-boto3-codebuild =
    buildMypyBoto3Package "codebuild" "1.36.0"
      "sha256-sft6FDJa7wUKP7jeSgtUvRHb4HP6UIcWeSgUY6j3qBk=";

  mypy-boto3-codecatalyst =
    buildMypyBoto3Package "codecatalyst" "1.36.0"
      "sha256-M1rNkJHIg7bld/Zl1mbQ+qn+AkHhbLWDAOCbcQQboI8=";

  mypy-boto3-codecommit =
    buildMypyBoto3Package "codecommit" "1.36.0"
      "sha256-bTP0rI6YS93GywxmzlRoEOljyg6iUJDwj7Qy0alF10k=";

  mypy-boto3-codedeploy =
    buildMypyBoto3Package "codedeploy" "1.36.0"
      "sha256-bQb0DWUMjztac9xXmsa/Mf2CghRTtqAu1KAhJAS+VMs=";

  mypy-boto3-codeguru-reviewer =
    buildMypyBoto3Package "codeguru-reviewer" "1.36.0"
      "sha256-fwabirSH8TCNdo7CcX61GCijhIazgNXtv890BLh2sWo=";

  mypy-boto3-codeguru-security =
    buildMypyBoto3Package "codeguru-security" "1.36.0"
      "sha256-FwQ2VE1frGm/2Fxb8yDJU6I0Dq0PANPpN8MpHGvT/e0=";

  mypy-boto3-codeguruprofiler =
    buildMypyBoto3Package "codeguruprofiler" "1.36.0"
      "sha256-5weqZgq2tnFneI4MXEAwunYBoUlDBJhSiptnXj5IeNk=";

  mypy-boto3-codepipeline =
    buildMypyBoto3Package "codepipeline" "1.36.0"
      "sha256-56dLbnU3QQ+rL/1oF+9bb/lOqDGStQjpKZX77IE2NrY=";

  mypy-boto3-codestar =
    buildMypyBoto3Package "codestar" "1.35.0"
      "sha256-B9Aq+hh9BOzCIYMkS21IZYb3tNCnKnV2OpSIo48aeJM=";

  mypy-boto3-codestar-connections =
    buildMypyBoto3Package "codestar-connections" "1.36.0"
      "sha256-OfDE5Ngx8+MkxcbX1T2EvA1ba6B9ISRVt4ryhHNYSjE=";

  mypy-boto3-codestar-notifications =
    buildMypyBoto3Package "codestar-notifications" "1.36.0"
      "sha256-PWvj/RzcfvUQugRLUkBcO8G69T2vNnsaB6y1EmZ+Pfo=";

  mypy-boto3-cognito-identity =
    buildMypyBoto3Package "cognito-identity" "1.36.0"
      "sha256-nO1+08anNtpqBSO8zIQs1p8bDAWYhFMp/bexSWWgBaE=";

  mypy-boto3-cognito-idp =
    buildMypyBoto3Package "cognito-idp" "1.36.0"
      "sha256-JgXToO2kEp5BHErZjIRBlDX7CCzlU6qurecwSW2ycG0=";

  mypy-boto3-cognito-sync =
    buildMypyBoto3Package "cognito-sync" "1.36.0"
      "sha256-vSKgq4NK3xODiaAm84Ad4BXWVRYmO2+5f0lZYUAVnQE=";

  mypy-boto3-comprehend =
    buildMypyBoto3Package "comprehend" "1.36.0"
      "sha256-xOanwN2CX9+0dF89nsKVOMqbKoQYFhhzXH2ZYVcs5to=";

  mypy-boto3-comprehendmedical =
    buildMypyBoto3Package "comprehendmedical" "1.36.0"
      "sha256-xG6gwY/pkE19QKs7WJ/0/XVJa4wvuqJvnnvgK3zOy5g=";

  mypy-boto3-compute-optimizer =
    buildMypyBoto3Package "compute-optimizer" "1.36.0"
      "sha256-DF4h2RSEqLUh/tBbM1hn+sJe7sgKE0Puru924M8AU20=";

  mypy-boto3-config =
    buildMypyBoto3Package "config" "1.36.0"
      "sha256-VK7/vxmSeMHYNow/ifwEYB8w/35PQfUiMhinyKNlDJ8=";

  mypy-boto3-connect =
    buildMypyBoto3Package "connect" "1.36.0"
      "sha256-Eo3LaVs+MjBJyjKrn5DStX0Gy1n/rnAejCuL1rc5xn0=";

  mypy-boto3-connect-contact-lens =
    buildMypyBoto3Package "connect-contact-lens" "1.36.0"
      "sha256-73ODpCcmgtPk5Zb8KzofJ7fiBPZamlLdFHWMN/uOtN8=";

  mypy-boto3-connectcampaigns =
    buildMypyBoto3Package "connectcampaigns" "1.36.0"
      "sha256-2wNQJFcUo9VO5387QSE1kGyTA8oHkFAPgdEIMdQqSo0=";

  mypy-boto3-connectcases =
    buildMypyBoto3Package "connectcases" "1.36.0"
      "sha256-QzmNIYpg/lCCxRMU8cuEM2TZEX7ZYLZPTI7pCHtyjXw=";

  mypy-boto3-connectparticipant =
    buildMypyBoto3Package "connectparticipant" "1.36.0"
      "sha256-2IkBKbj+u5X6PJu4geV51jO9oCq02t22rUCq9VTmJZo=";

  mypy-boto3-controltower =
    buildMypyBoto3Package "controltower" "1.36.0"
      "sha256-WLflw9l+Hl+fhdQzVECiTo18Wl1vvE1bx8Rut3/y9uA=";

  mypy-boto3-cur =
    buildMypyBoto3Package "cur" "1.36.0"
      "sha256-9XuhrMQH+zXq2JaRgwXYUMQcVcuqTNHyfuj47gC4OZY=";

  mypy-boto3-customer-profiles =
    buildMypyBoto3Package "customer-profiles" "1.36.0"
      "sha256-V9sxGG4Fb/h1hLzHI/S63hx91KiA8vKd0kFxL4LHUtE=";

  mypy-boto3-databrew =
    buildMypyBoto3Package "databrew" "1.36.0"
      "sha256-IrLzHBqQpINtGnwBdkXusY7QLE9puKbZmaWCEy2br98=";

  mypy-boto3-dataexchange =
    buildMypyBoto3Package "dataexchange" "1.36.0"
      "sha256-PWkUc6sIG/PufTPU+nTnPvWy9xs/d6itT1yx8W7OvCA=";

  mypy-boto3-datapipeline =
    buildMypyBoto3Package "datapipeline" "1.36.0"
      "sha256-BThesaer2rOGyx8OtRo6cWQoX2xnyTgSgi3amd+qDrU=";

  mypy-boto3-datasync =
    buildMypyBoto3Package "datasync" "1.36.0"
      "sha256-THPRUkDTeUFwsWUKU3I8OcZ+U2VsqY56zhVLqhUml6U=";

  mypy-boto3-dax =
    buildMypyBoto3Package "dax" "1.36.0"
      "sha256-UkuWWk99OTXMMhYMuAby9rbJjlhYBI0WwA9clnz4U9A=";

  mypy-boto3-detective =
    buildMypyBoto3Package "detective" "1.36.0"
      "sha256-qumyLsWuOFuwiBK1XN558ag8LlEA5jfHofy5dKK+Gbw=";

  mypy-boto3-devicefarm =
    buildMypyBoto3Package "devicefarm" "1.36.0"
      "sha256-IipLmvFCzQ9GA8BcOtRwORY+RORxS2UArh+qmcY/sKM=";

  mypy-boto3-devops-guru =
    buildMypyBoto3Package "devops-guru" "1.36.0"
      "sha256-2B9WXAldrhCN91Bfpy14FU6nW4IFi8tbyc+ToppCzFU=";

  mypy-boto3-directconnect =
    buildMypyBoto3Package "directconnect" "1.36.0"
      "sha256-vsQqIfI1pCzglFLq6/3NU+V98viLpOXe7ga3t4RhSRE=";

  mypy-boto3-discovery =
    buildMypyBoto3Package "discovery" "1.36.0"
      "sha256-eEgRtTa8uwRsrixtrGrnn2vRSrHC+a3FXVtrt1t3DmY=";

  mypy-boto3-dlm =
    buildMypyBoto3Package "dlm" "1.36.0"
      "sha256-si7pjgKzxg++SfVdOsIQP37rXG84IZM0ltcwc2+wn3I=";

  mypy-boto3-dms =
    buildMypyBoto3Package "dms" "1.36.0"
      "sha256-T7Da/0cuPsW40hwa/FEXFF4trMSBzNumOI0eOdMHZjE=";

  mypy-boto3-docdb =
    buildMypyBoto3Package "docdb" "1.36.0"
      "sha256-gDpPgNv3/zpJDnQr50BA4Khylz1HKwghNN4QKwHm28U=";

  mypy-boto3-docdb-elastic =
    buildMypyBoto3Package "docdb-elastic" "1.36.0"
      "sha256-+eIiLbW/GBQkx0yfwUmxTAPGCUGxUCgTrkDWXJZNHfc=";

  mypy-boto3-drs =
    buildMypyBoto3Package "drs" "1.36.0"
      "sha256-knGzFh7hI8OFxMIMtix8TRw4QsOymWg44sTX+3Iu8aA=";

  mypy-boto3-ds =
    buildMypyBoto3Package "ds" "1.36.0"
      "sha256-8aWD6LDmLO9htE7SO2xu0IMRdRcSGrO3+NQNtR439MM=";

  mypy-boto3-dynamodb =
    buildMypyBoto3Package "dynamodb" "1.36.0"
      "sha256-FofkaJI2pTkXVRJuhuwlltQI65VAjDGsCaPR6yidUW0=";

  mypy-boto3-dynamodbstreams =
    buildMypyBoto3Package "dynamodbstreams" "1.36.0"
      "sha256-TSLvTHGLuEIAsJnlaeCwrOgX+Sgl2cqUkxURwHGZsPg=";

  mypy-boto3-ebs =
    buildMypyBoto3Package "ebs" "1.36.0"
      "sha256-YrzTW5fEsZPDu4p84jhY4avS/wM01XybrvGCOtF48cQ=";

  mypy-boto3-ec2 =
    buildMypyBoto3Package "ec2" "1.36.0"
      "sha256-/dFXF0dKEF0wPQoh04dY9X0x8JqaxgFLtOYJocBwshA=";

  mypy-boto3-ec2-instance-connect =
    buildMypyBoto3Package "ec2-instance-connect" "1.36.0"
      "sha256-q6u1MssNxk38vE2Gy/508A5bhdUrqxH/Mq3DeBFVfqA=";

  mypy-boto3-ecr =
    buildMypyBoto3Package "ecr" "1.36.0"
      "sha256-ZCGpMLVliE01R1c+qomlyo4TELGfWZuSICdMeVvFxL4=";

  mypy-boto3-ecr-public =
    buildMypyBoto3Package "ecr-public" "1.36.0"
      "sha256-ezh5me1scgEEH0I/19CSVDstsLkwYgdVhwPuVivbKWk=";

  mypy-boto3-ecs =
    buildMypyBoto3Package "ecs" "1.36.0"
      "sha256-uO/y0aDNH4aayyvRDFH/WedHTku0A8QRvrzCe34P6gY=";

  mypy-boto3-efs =
    buildMypyBoto3Package "efs" "1.36.0"
      "sha256-5xK6JX8tM+3EDHC5Ma4G6fGYSf/9Q1V7O2YS+E20HOo=";

  mypy-boto3-eks =
    buildMypyBoto3Package "eks" "1.36.0"
      "sha256-G4kIlOE/2SYhP0JzX0jmu3al7UbU0wwTx/lVAP19JQ0=";

  mypy-boto3-elastic-inference =
    buildMypyBoto3Package "elastic-inference" "1.36.0"
      "sha256-duU3LIeW3FNiplVmduZsNXBoDK7vbO6ecrBt1Y7C9rU=";

  mypy-boto3-elasticache =
    buildMypyBoto3Package "elasticache" "1.36.0"
      "sha256-lFQJUk53Hc9ocDGPdOWFe/tD0gu1IfTohQTJwAdFjRE=";

  mypy-boto3-elasticbeanstalk =
    buildMypyBoto3Package "elasticbeanstalk" "1.36.0"
      "sha256-kWYiIJm+i5qrKHzOlNYVJt7uESE0RYOYYLJhRSvpMuo=";

  mypy-boto3-elastictranscoder =
    buildMypyBoto3Package "elastictranscoder" "1.36.0"
      "sha256-uJa3jqLs1PT+JnqoULgS+BhJq2puEQeI+8ai9jfiw44=";

  mypy-boto3-elb =
    buildMypyBoto3Package "elb" "1.36.0"
      "sha256-jfF0FDyLYqOObAjD5NOzDeyVIx0yQ9PpWmGXPR6S8i0=";

  mypy-boto3-elbv2 =
    buildMypyBoto3Package "elbv2" "1.36.0"
      "sha256-B483GDsM1gyxF875fq9+JJcMu/RY+el5NsUB477QN88=";

  mypy-boto3-emr =
    buildMypyBoto3Package "emr" "1.36.0"
      "sha256-j61F+3E2FfQ7hpsnT9M/7maaL/uKNNlRhm8cKH5RoAo=";

  mypy-boto3-emr-containers =
    buildMypyBoto3Package "emr-containers" "1.36.0"
      "sha256-2YTbWlv98Ldoj7w/MDcKNH40V88NjSYN+CwnZugufE4=";

  mypy-boto3-emr-serverless =
    buildMypyBoto3Package "emr-serverless" "1.36.0"
      "sha256-z2cvFzYgx+9ud+ZbWi+Dr2HMJJcPaaSOghFw7CDzj8w=";

  mypy-boto3-entityresolution =
    buildMypyBoto3Package "entityresolution" "1.36.0"
      "sha256-8AYX5ZmyC08SXL7Ahuj0do4hngw0Tc8aIKSQOBqLDhU=";

  mypy-boto3-es =
    buildMypyBoto3Package "es" "1.36.0"
      "sha256-6spN2EnD4ZLu0app85PgOVuSu0vFyPOeAootshpBDTM=";

  mypy-boto3-events =
    buildMypyBoto3Package "events" "1.36.0"
      "sha256-9fRXPt5L32Rc1qa0na4OCJbyYZWemAszatW4SRMcO/I=";

  mypy-boto3-evidently =
    buildMypyBoto3Package "evidently" "1.36.0"
      "sha256-ZL6PFxN2uN8qehPqNE+SRVxi5qiPlSph4bJC5pvU5O8=";

  mypy-boto3-finspace =
    buildMypyBoto3Package "finspace" "1.36.0"
      "sha256-sSigyHiVmF4AJ00H0W+G34E1nU1cOZoZcg+qmgsl5sk=";

  mypy-boto3-finspace-data =
    buildMypyBoto3Package "finspace-data" "1.36.0"
      "sha256-Jkf9euVgG4wY8vyMfj1FV973DxZjly1lNZ5MKN/b6WA=";

  mypy-boto3-firehose =
    buildMypyBoto3Package "firehose" "1.36.0"
      "sha256-4rg+/mUkoFhYUQ5E46VAJCT6zPDxWo4fYXBnQzkfLDI=";

  mypy-boto3-fis =
    buildMypyBoto3Package "fis" "1.36.0"
      "sha256-uIQeN0Az//PtIB17Pqe6XShCGj2tPHkeNPnMhDaBcaA=";

  mypy-boto3-fms =
    buildMypyBoto3Package "fms" "1.36.0"
      "sha256-18L9i0t/98USqXxSujbvE6hkxA6FHELJemiTdqLfxLM=";

  mypy-boto3-forecast =
    buildMypyBoto3Package "forecast" "1.36.0"
      "sha256-9sT/Ie3KDssXQs48WdY/ALcJG/ONEg+za275ACXNb/M=";

  mypy-boto3-forecastquery =
    buildMypyBoto3Package "forecastquery" "1.36.0"
      "sha256-TWypDz0ZRrNI4D6VV6lDHrlfWCeTOETspmEx1Pj1wCk=";

  mypy-boto3-frauddetector =
    buildMypyBoto3Package "frauddetector" "1.35.93"
      "sha256-50OikIHDj1ehdSVQAdzhKz+EzS1E1AeyIM/cXd5/XXg=";

  mypy-boto3-fsx =
    buildMypyBoto3Package "fsx" "1.35.93"
      "sha256-NlmJgjTeCSSoQByq4vF2/4zuZ+4L6SQ8ORV0LtzNwq8=";

  mypy-boto3-gamelift =
    buildMypyBoto3Package "gamelift" "1.35.93"
      "sha256-QU4Nz2KaB43qJuRTc56hPYXgURyhUSS9vR1KmB26RXI=";

  mypy-boto3-glacier =
    buildMypyBoto3Package "glacier" "1.35.93"
      "sha256-7Mv0+Cu/6tq5eQnDEQZE4jWO7PrUMIaetq+6t/aN5nw=";

  mypy-boto3-globalaccelerator =
    buildMypyBoto3Package "globalaccelerator" "1.35.93"
      "sha256-Vyx6ki0OtFy7nnTm0DxEYvFaGfRkK0YYty/cCLU5TM4=";

  mypy-boto3-glue =
    buildMypyBoto3Package "glue" "1.35.93"
      "sha256-J3Wag/+lQUslidqDYlgWo8fLl2AP7GhXi9MBKpriDug=";

  mypy-boto3-grafana =
    buildMypyBoto3Package "grafana" "1.35.93"
      "sha256-o0/B9yPZKyiggMUJYLgaJuoeK61jmpadsMGRRSE/RZU=";

  mypy-boto3-greengrass =
    buildMypyBoto3Package "greengrass" "1.35.93"
      "sha256-aGXxwcBZ8A1OL1QmG9CqWQKlH6QkqjVxlEk6XQaVPAA=";

  mypy-boto3-greengrassv2 =
    buildMypyBoto3Package "greengrassv2" "1.35.93"
      "sha256-InQ8WIxTkSixj8nEJZ0Qghs9MJ8i6QzfoTaU5ZGmx4k=";

  mypy-boto3-groundstation =
    buildMypyBoto3Package "groundstation" "1.35.93"
      "sha256-4Ybro/al/yjNUZJzKtrC8mzat9VjGb5LqGDPzrMeOz0=";

  mypy-boto3-guardduty =
    buildMypyBoto3Package "guardduty" "1.35.93"
      "sha256-ogD3HW2MDtzMhhVLG12EVZp/F/b9JrEGJqBrTLGSTAE=";

  mypy-boto3-health =
    buildMypyBoto3Package "health" "1.35.93"
      "sha256-OL5BSCSNNdu0l572Ql1Ayn5jASHurvhVnQUjIS5DTXQ=";

  mypy-boto3-healthlake =
    buildMypyBoto3Package "healthlake" "1.35.93"
      "sha256-sgIVxItk/Ow4BiLdbx2PMkRipTdULxX64pp/ixZbrgI=";

  mypy-boto3-iam =
    buildMypyBoto3Package "iam" "1.35.93"
      "sha256-JZXI2sQG5Odx07fXg1+qy5NtIESbnN0XpT8HYhnMdxI=";

  mypy-boto3-identitystore =
    buildMypyBoto3Package "identitystore" "1.35.93"
      "sha256-qSuSaVpjEzdjr9vwH74IibWAiiiQRkXqn+wKWWTU+u0=";

  mypy-boto3-imagebuilder =
    buildMypyBoto3Package "imagebuilder" "1.35.94"
      "sha256-Cj3//KC7Au8xn0NHjLH5yGjbpHFQL80EXhuMSHTlIAc=";

  mypy-boto3-importexport =
    buildMypyBoto3Package "importexport" "1.35.93"
      "sha256-sS+E55GkpEaO/lixkQZulvX7OWjOY9p4L2ysKNvqXKg=";

  mypy-boto3-inspector =
    buildMypyBoto3Package "inspector" "1.35.93"
      "sha256-R4ksUkE7JINvc0PdAn/CBIMCUPH7eJV1zBjhZryuVcg=";

  mypy-boto3-inspector2 =
    buildMypyBoto3Package "inspector2" "1.35.93"
      "sha256-6I+sYTmbs7HGF+1SFFAYCQorQ91mvWFJTvgygVp4oUo=";

  mypy-boto3-internetmonitor =
    buildMypyBoto3Package "internetmonitor" "1.35.93"
      "sha256-EI/Gl6Cto8hVh8TpnfMh6GqTyp4V9yVa9bDKW86GO2E=";

  mypy-boto3-iot =
    buildMypyBoto3Package "iot" "1.35.93"
      "sha256-ZLs86Cx10TPy3HflnOAv02VItU/uWLyesGYkyAF6JvI=";

  mypy-boto3-iot-data =
    buildMypyBoto3Package "iot-data" "1.35.93"
      "sha256-5kw/Vw97r9HjFtSnD/eE+qT93S3f2P2ctvAB1A6CMMc=";

  mypy-boto3-iot-jobs-data =
    buildMypyBoto3Package "iot-jobs-data" "1.35.93"
      "sha256-wickduc7XoSsCc/8H/7POat2CYEeeW/GcxG9dJql05Q=";

  mypy-boto3-iot1click-devices =
    buildMypyBoto3Package "iot1click-devices" "1.35.93"
      "sha256-fwfuhSitYIJW5QswYdZ8ZpNL3AEg6MXhJitbbU48STs=";

  mypy-boto3-iot1click-projects =
    buildMypyBoto3Package "iot1click-projects" "1.35.93"
      "sha256-LFuz5/nCZGpSfgqyswxn80VzxXsqzZlBFqPtPJ8bzgo=";

  mypy-boto3-iotanalytics =
    buildMypyBoto3Package "iotanalytics" "1.35.93"
      "sha256-ycY1Gz0SaU7AbyMwnHKBHYF9J4luwlKHPsCgGIDzpJc=";

  mypy-boto3-iotdeviceadvisor =
    buildMypyBoto3Package "iotdeviceadvisor" "1.35.93"
      "sha256-poktyeSfAizee/UbmnyvgkKOMN4PKtnlnJWYuIbmQmk=";

  mypy-boto3-iotevents =
    buildMypyBoto3Package "iotevents" "1.35.93"
      "sha256-vr/U3mjDol42+heZBKgAGcCoy4RLOK5wUauflCXl418=";

  mypy-boto3-iotevents-data =
    buildMypyBoto3Package "iotevents-data" "1.35.93"
      "sha256-nnyrY0rtVmggFBCvNqmVbb5IiAorhZRAewwyXVkjMt0=";

  mypy-boto3-iotfleethub =
    buildMypyBoto3Package "iotfleethub" "1.35.93"
      "sha256-73bCQen8CzXszpG06nSCATt2lHOT1E8V8PUg0XLMqY8=";

  mypy-boto3-iotfleetwise =
    buildMypyBoto3Package "iotfleetwise" "1.35.93"
      "sha256-jNykp2IjsC3JPjwodn/xmvJz6fTMOrIr/ijcefUZBmw=";

  mypy-boto3-iotsecuretunneling =
    buildMypyBoto3Package "iotsecuretunneling" "1.35.93.post1"
      "sha256-LmKNUXOP8tsoajo3t9H2x/TJBNo8z6SsyTjn4tDp82Q=";

  mypy-boto3-iotsitewise =
    buildMypyBoto3Package "iotsitewise" "1.35.93"
      "sha256-d1Lhj2/izhVGJiIP37NhMEvz/RMzWuw6NpFskWoN7FA=";

  mypy-boto3-iotthingsgraph =
    buildMypyBoto3Package "iotthingsgraph" "1.35.93"
      "sha256-pDRu3al9uBr5wkEcMmOVRr3Ops7pPs6XN7rmy2ZCcxQ=";

  mypy-boto3-iottwinmaker =
    buildMypyBoto3Package "iottwinmaker" "1.35.93"
      "sha256-IwnLmn0a+hofj7tf1Dhv4ybtwa7IerTmrEV9iu6qNmM=";

  mypy-boto3-iotwireless =
    buildMypyBoto3Package "iotwireless" "1.35.93"
      "sha256-uKdd8g53jc6CC9ctrH+JcYhLBN2Me2qGueuimF9imE0=";

  mypy-boto3-ivs =
    buildMypyBoto3Package "ivs" "1.35.93"
      "sha256-fcn9TZwSyut4VKJPzuAPxaK8GzR0MnnK9+9W3EZ01JQ=";

  mypy-boto3-ivs-realtime =
    buildMypyBoto3Package "ivs-realtime" "1.35.93"
      "sha256-6vqX+gkajl6N4EPusz9DwDCHDfswMH4/f13afD33x2A=";

  mypy-boto3-ivschat =
    buildMypyBoto3Package "ivschat" "1.35.93"
      "sha256-z09uzdTF4r8hPciAJ7gTyMaJ60CFqfMD+JajtNwP1yc=";

  mypy-boto3-kafka =
    buildMypyBoto3Package "kafka" "1.35.93"
      "sha256-i1vARhAsw7mXRBVMVicEgz+7hHWTdjqyF5qf+QVXjCI=";

  mypy-boto3-kafkaconnect =
    buildMypyBoto3Package "kafkaconnect" "1.35.98"
      "sha256-P2PMe4zzm4pUSa9GsuwNksl/4Ry/KuDJUOqO9f3phog=";

  mypy-boto3-kendra =
    buildMypyBoto3Package "kendra" "1.35.93"
      "sha256-sDDmDAjKRUgm9G9SFIbMxHO9BDPuRSDerfP4H6nEq1A=";

  mypy-boto3-kendra-ranking =
    buildMypyBoto3Package "kendra-ranking" "1.35.93"
      "sha256-sION3AXWCJXN1nz0nfnvhTsXX1w6FhHHhRTkyC6jv9g=";

  mypy-boto3-keyspaces =
    buildMypyBoto3Package "keyspaces" "1.35.93"
      "sha256-BSXcQOv0yAYNw64fClbZbaR4JME9ERIY2+RZuefs2hg=";

  mypy-boto3-kinesis =
    buildMypyBoto3Package "kinesis" "1.35.93"
      "sha256-8HGPW1S5VXYXkLSzO9yrjQx3m9UMxnHGhiqOBVRRW9o=";

  mypy-boto3-kinesis-video-archived-media =
    buildMypyBoto3Package "kinesis-video-archived-media" "1.35.93"
      "sha256-HdL3FbTVYAXKpM7VW0NXqpgmeGg8P0Ug/+Li5Hj8A1o=";

  mypy-boto3-kinesis-video-media =
    buildMypyBoto3Package "kinesis-video-media" "1.35.93"
      "sha256-+g6VfYlaiV/bFXdn79rQ5j9f+ijg+dvwFz0Gg2F6taQ=";

  mypy-boto3-kinesis-video-signaling =
    buildMypyBoto3Package "kinesis-video-signaling" "1.35.93"
      "sha256-DWWQfygar1pwQUYol3ZvBHr5nbBIeFJQM384CBHnfP0=";

  mypy-boto3-kinesis-video-webrtc-storage =
    buildMypyBoto3Package "kinesis-video-webrtc-storage" "1.35.93"
      "sha256-sR1ZRhrSVR5vka4snBaoMu7vCrux/2jI8IN1rdZSP40=";

  mypy-boto3-kinesisanalytics =
    buildMypyBoto3Package "kinesisanalytics" "1.35.93"
      "sha256-jKiNeL0ACrDyJ5UsveTG+xZFs4jUE1HCCp/xCecBqNU=";

  mypy-boto3-kinesisanalyticsv2 =
    buildMypyBoto3Package "kinesisanalyticsv2" "1.35.93"
      "sha256-4AzUzHV5NXUfw+YzClZtJSdxDyT4gk/yzvW8E0odz0w=";

  mypy-boto3-kinesisvideo =
    buildMypyBoto3Package "kinesisvideo" "1.35.93"
      "sha256-+o1vQSZKwVa24qyItKjoXI3TFlVCkYF+wJIR9/2uTco=";

  mypy-boto3-kms =
    buildMypyBoto3Package "kms" "1.35.93"
      "sha256-kpNhOUiGzGZoqyTqUl0IlHoNSco60uttn9PC6LRi86Y=";

  mypy-boto3-lakeformation =
    buildMypyBoto3Package "lakeformation" "1.35.93"
      "sha256-asICrCujW0F1DFVrUB0Mwjvk17vqZj9VIGkLK4Mu8Kw=";

  mypy-boto3-lambda =
    buildMypyBoto3Package "lambda" "1.35.93"
      "sha256-wRsEd0PHY16oOFq/+vl3iKEItxR5YS6bXn0LsZAp16Q=";

  mypy-boto3-lex-models =
    buildMypyBoto3Package "lex-models" "1.35.93"
      "sha256-vR6J868Gl3YoKWqGmiiBLEDbLi6edfseGSjF0LPWYgg=";

  mypy-boto3-lex-runtime =
    buildMypyBoto3Package "lex-runtime" "1.35.93"
      "sha256-RiGbnx07ErTP/kHDrudTrNinaDMt/1bkb+tDpQPD+Do=";

  mypy-boto3-lexv2-models =
    buildMypyBoto3Package "lexv2-models" "1.35.93"
      "sha256-uemBDjrzUGaEq7T8te/ka7xwpkPhix2On47DHZWyiLE=";

  mypy-boto3-lexv2-runtime =
    buildMypyBoto3Package "lexv2-runtime" "1.35.93"
      "sha256-b3A2qdC2aR1Z1/o1DnhA4DNxyy0IhQLFoGw8iurraEQ=";

  mypy-boto3-license-manager =
    buildMypyBoto3Package "license-manager" "1.35.93"
      "sha256-8BhNvneehbL5gT/xqXKCXtgbQuHYd5W7QdXc1g6UXgY=";

  mypy-boto3-license-manager-linux-subscriptions =
    buildMypyBoto3Package "license-manager-linux-subscriptions" "1.35.93"
      "sha256-vWkI8O+7gypV32xfKa03p1u2afSlRsjiJG8CxFHkPvs=";

  mypy-boto3-license-manager-user-subscriptions =
    buildMypyBoto3Package "license-manager-user-subscriptions" "1.35.93"
      "sha256-F4lbO1pB10yQ7XWCiWOjq5nm8mofhwMsbKBUd9kM5xw=";

  mypy-boto3-lightsail =
    buildMypyBoto3Package "lightsail" "1.35.93"
      "sha256-dMsQ4O20MVGb4akSZA3KWTIN3cLKPM0Ef5mjJ2Ct4x8=";

  mypy-boto3-location =
    buildMypyBoto3Package "location" "1.35.93"
      "sha256-qTy3TrRLg8hDgPBb4YXpvaWcZu8o7QNUS4iM3KCc9Ow=";

  mypy-boto3-logs =
    buildMypyBoto3Package "logs" "1.35.93"
      "sha256-jvJiTj2EZpUygYK2R6hvhfy0p4ZA7RX3FnCfkGIqNps=";

  mypy-boto3-lookoutequipment =
    buildMypyBoto3Package "lookoutequipment" "1.35.93"
      "sha256-rpkFqQY36GYHEOXXiygCUYjq9ikrYNhVktCcIDC/gVo=";

  mypy-boto3-lookoutmetrics =
    buildMypyBoto3Package "lookoutmetrics" "1.35.93"
      "sha256-1NiLAfb72oyHmnidK6XxJwq3Rr7MCAVwKufnXsho+rY=";

  mypy-boto3-lookoutvision =
    buildMypyBoto3Package "lookoutvision" "1.35.93"
      "sha256-COSy+dty349kKHZ9eN9C2C64KiNdMCmSZPNVtzptG/M=";

  mypy-boto3-m2 =
    buildMypyBoto3Package "m2" "1.35.93"
      "sha256-V4pIgRkTseN9FR0XLIw1lDMTk94QsVlZRlkr20h0in8=";

  mypy-boto3-machinelearning =
    buildMypyBoto3Package "machinelearning" "1.35.93"
      "sha256-osz/sOnbGQ3oMHUJqGKT5W4qdgFzsBy6TCJHmtYKxT4=";

  mypy-boto3-macie2 =
    buildMypyBoto3Package "macie2" "1.35.93"
      "sha256-wUxm28vigkr09Uz1ZdUO3pMRZz1DQJiOlWglNotSjOI=";

  mypy-boto3-managedblockchain =
    buildMypyBoto3Package "managedblockchain" "1.35.93"
      "sha256-RprF634l7cHRrDiuFJYztUsXTw5MWFEAwgK1vHBy9Dw=";

  mypy-boto3-managedblockchain-query =
    buildMypyBoto3Package "managedblockchain-query" "1.35.93"
      "sha256-K47zi16yqu7aliCuEX6IBLnYtA3v/ItSjAEj7ZN+U6c=";

  mypy-boto3-marketplace-catalog =
    buildMypyBoto3Package "marketplace-catalog" "1.35.93"
      "sha256-5T4/e2X2wTA388SsuEJsuyygvgZ7xHZM/RBYCA3/vA4=";

  mypy-boto3-marketplace-entitlement =
    buildMypyBoto3Package "marketplace-entitlement" "1.35.93"
      "sha256-mYcdZgr3tuawy6c0g7HTwFp7pglW3Nfe2X7YzYCbEMc=";

  mypy-boto3-marketplacecommerceanalytics =
    buildMypyBoto3Package "marketplacecommerceanalytics" "1.35.93"
      "sha256-0c3CH8kjbKy1XBLuQsdH4Wy/RX1BjbTuiG01WoG6MwA=";

  mypy-boto3-mediaconnect =
    buildMypyBoto3Package "mediaconnect" "1.35.93"
      "sha256-/0GlzFATVbQX/ivbBWItTGglIQoeyACgMb1H3x9ELRM=";

  mypy-boto3-mediaconvert =
    buildMypyBoto3Package "mediaconvert" "1.35.93"
      "sha256-EmRIwSS0LJ2UcxTSk5zru6XiNz4yj6ICyeZrEDFHcgU=";

  mypy-boto3-medialive =
    buildMypyBoto3Package "medialive" "1.35.93"
      "sha256-9FIEwwIVQY4LCBf6qwl/9YhkxZKWeZwFptjjrGsBLnQ=";

  mypy-boto3-mediapackage =
    buildMypyBoto3Package "mediapackage" "1.35.93"
      "sha256-evtFa4HEUCbQfGl0SP+fK3opaexMSSTPK5IVGw/3XmQ=";

  mypy-boto3-mediapackage-vod =
    buildMypyBoto3Package "mediapackage-vod" "1.35.93"
      "sha256-HkuKVGXzgPsVCsLvzpceohvWT/qrE+ulrXkG6c220rs=";

  mypy-boto3-mediapackagev2 =
    buildMypyBoto3Package "mediapackagev2" "1.35.93"
      "sha256-P98TNjrzeM5OiOr6SDhwyuDCQQxhiHAS8vh9Ehi0YvY=";

  mypy-boto3-mediastore =
    buildMypyBoto3Package "mediastore" "1.35.93"
      "sha256-Ti27FZqg0cZBbjWr3ZpwFkiv/fkJYQQLO2V5yKE/TCk=";

  mypy-boto3-mediastore-data =
    buildMypyBoto3Package "mediastore-data" "1.35.93"
      "sha256-X1ut0sz01EtToXCQ2/5s+eOLmZxqIH26VuknPWtAWGc=";

  mypy-boto3-mediatailor =
    buildMypyBoto3Package "mediatailor" "1.35.93"
      "sha256-YCUjEIfBMZObiihr/UeXuuINaKLtqKgEDKTUTeFUXfI=";

  mypy-boto3-medical-imaging =
    buildMypyBoto3Package "medical-imaging" "1.35.93"
      "sha256-kfHPYSXNrHt8gVW+UswvR4OikCE37+D+A5V1cgGixJY=";

  mypy-boto3-memorydb =
    buildMypyBoto3Package "memorydb" "1.35.93"
      "sha256-6LmB1kUjFSo+Swj4HRvRfP5+oWCngOeqTOYIhSHLT4M=";

  mypy-boto3-meteringmarketplace =
    buildMypyBoto3Package "meteringmarketplace" "1.35.93"
      "sha256-Y1fh2Aon2+Ss/Ts7+37+lIhhqoJCos9c6x0CbVd8jqg=";

  mypy-boto3-mgh =
    buildMypyBoto3Package "mgh" "1.35.93"
      "sha256-q7tSU6e4NjruCoy4FuEyydyDmYdsuxargiIi7qw/H0g=";

  mypy-boto3-mgn =
    buildMypyBoto3Package "mgn" "1.35.93"
      "sha256-2pccXkqFGOW2H8wOtmqLKspypQe3vADgH6aAceON/Uw=";

  mypy-boto3-migration-hub-refactor-spaces =
    buildMypyBoto3Package "migration-hub-refactor-spaces" "1.35.93"
      "sha256-TIU/p8aSFv6euEVqLROpteHWCa7ep6VY2uuFIVz/3QE=";

  mypy-boto3-migrationhub-config =
    buildMypyBoto3Package "migrationhub-config" "1.35.93"
      "sha256-dyJONb1ZeO70br+DUpaXJyZcze8X/eQXiZFdP760GoA=";

  mypy-boto3-migrationhuborchestrator =
    buildMypyBoto3Package "migrationhuborchestrator" "1.35.93"
      "sha256-FkCSJh+DhReaqcX+P1i7AfGLPGToqqZfM7B5d682Qg4=";

  mypy-boto3-migrationhubstrategy =
    buildMypyBoto3Package "migrationhubstrategy" "1.35.93"
      "sha256-FxU8y044Kc2LVRUJ+1CI9f6uNVz/KsH2p0ALzKv0EM8=";

  mypy-boto3-mq =
    buildMypyBoto3Package "mq" "1.35.93"
      "sha256-JdHIZ2F3AbRGQWKIXucgh71taOPQva493A5udjYnscI=";

  mypy-boto3-mturk =
    buildMypyBoto3Package "mturk" "1.35.93"
      "sha256-GidFaCIJU1dsHAu56lwH9WfH8w30Yv0r36NFZw0jSf0=";

  mypy-boto3-mwaa =
    buildMypyBoto3Package "mwaa" "1.35.93"
      "sha256-/rFNmGFNu6Z5pbdUz+iozzTfTIIuTUvpKuO1wXZBkss=";

  mypy-boto3-neptune =
    buildMypyBoto3Package "neptune" "1.35.93"
      "sha256-acu+9iik8v4kxP01ZcAZprnloh3PTatjwLK73Vhe5gI=";

  mypy-boto3-neptunedata =
    buildMypyBoto3Package "neptunedata" "1.35.93"
      "sha256-2C59MndwDEwf3Jzdc6H/wHSeSAzY6eseBlt404Twn9A=";

  mypy-boto3-network-firewall =
    buildMypyBoto3Package "network-firewall" "1.35.93"
      "sha256-UFgOmnlfdb2+Bu7YNHSthCaIF0ka1VGC1JN/wZTihYY=";

  mypy-boto3-networkmanager =
    buildMypyBoto3Package "networkmanager" "1.35.93"
      "sha256-4xU3vZf8uQnJEhmuLe2bR1//bxFUprlhpPNz1FTT/XM=";

  mypy-boto3-nimble =
    buildMypyBoto3Package "nimble" "1.35.0"
      "sha256-gs9eGyRaZN7Fsl0D5fSqtTiYZ+Exp0s8QW/X8ZR7guA=";

  mypy-boto3-oam =
    buildMypyBoto3Package "oam" "1.35.93"
      "sha256-t0JW1y9tCN+UwXPLtEuvt8DH2Ce1Hq7FPzIUKA2qSM4=";

  mypy-boto3-omics =
    buildMypyBoto3Package "omics" "1.35.93"
      "sha256-p81sM5vBEj7ZqHOiQj7uWmhlJqxbfTmhrymH8l2oQJ8=";

  mypy-boto3-opensearch =
    buildMypyBoto3Package "opensearch" "1.35.93"
      "sha256-9/H2wn8F8a0PweerH1pRc60i5bYyV5rtWf5bC9Oa2EA=";

  mypy-boto3-opensearchserverless =
    buildMypyBoto3Package "opensearchserverless" "1.35.93"
      "sha256-O+EW/7HeYxTQ2e77ISDX8cg0RyEHjLvuzg51jIelDEE=";

  mypy-boto3-opsworks =
    buildMypyBoto3Package "opsworks" "1.35.93"
      "sha256-knw8p9+CsyXZxXA1RDK1h+Yjj7DuatUFUKFGETLFQmY=";

  mypy-boto3-opsworkscm =
    buildMypyBoto3Package "opsworkscm" "1.35.93"
      "sha256-ZXsNfHBwFZccRF9/l+v/zvJYzHa7DyVe6EcGGOkBgds=";

  mypy-boto3-organizations =
    buildMypyBoto3Package "organizations" "1.35.93"
      "sha256-ujkWfeAUraDvsex35bUKHYlVkWZUw0TH1aczSYD5bIM=";

  mypy-boto3-osis =
    buildMypyBoto3Package "osis" "1.35.93"
      "sha256-eSJ+4Ms6ae4Cf7GqABSXf6O5sCHZP9OvvesVBVFlCxQ=";

  mypy-boto3-outposts =
    buildMypyBoto3Package "outposts" "1.35.93"
      "sha256-bFiFu2Ib6a+smhrjdgrIEFsUIH1hpgsWHVN0BhveoHo=";

  mypy-boto3-panorama =
    buildMypyBoto3Package "panorama" "1.35.93"
      "sha256-krj+UW1gcbDTVVChLs0Ep4wqMzTEpJ8bcgS1bBM1FDE=";

  mypy-boto3-payment-cryptography =
    buildMypyBoto3Package "payment-cryptography" "1.35.93"
      "sha256-RMpoj+A3jijFH0J/MDqD/jgmR0TpdSi2NSdYqYhKCDM=";

  mypy-boto3-payment-cryptography-data =
    buildMypyBoto3Package "payment-cryptography-data" "1.35.93"
      "sha256-2zbM/jxnIqgIdWSQPPujrf79mt6p1BP1MtVxiSRGMzg=";

  mypy-boto3-pca-connector-ad =
    buildMypyBoto3Package "pca-connector-ad" "1.35.93"
      "sha256-pAhbU/iVEc0NRMUNy1fBTV8rGa4TLeW3K1s6caXYI9g=";

  mypy-boto3-personalize =
    buildMypyBoto3Package "personalize" "1.35.93"
      "sha256-SxrKT8hIWR+Wg3vcZSct5/DfoZZgR0yyKicowLmM+DI=";

  mypy-boto3-personalize-events =
    buildMypyBoto3Package "personalize-events" "1.35.93"
      "sha256-r/zotloeRFPWMc9wYwerTvjNpJwikIPVoRDOcLrrHpg=";

  mypy-boto3-personalize-runtime =
    buildMypyBoto3Package "personalize-runtime" "1.35.93"
      "sha256-JG6bddmNMt/1Zd8xWx9IZesyHWqzp9hWFxEvAlZUUtw=";

  mypy-boto3-pi =
    buildMypyBoto3Package "pi" "1.35.93"
      "sha256-85J3KDQQP0pQJHtFJBnlBBtKYpea5epA5EcC2+sT8bI=";

  mypy-boto3-pinpoint =
    buildMypyBoto3Package "pinpoint" "1.35.93"
      "sha256-g7Kyqzg1Pqh5r9AwDQ8RPXny4DTN/v36Lq/kEjCi7GU=";

  mypy-boto3-pinpoint-email =
    buildMypyBoto3Package "pinpoint-email" "1.35.93"
      "sha256-+9jGCsasNPUCsvnyC5lEp9NeoYcIiWyEq41Qh+OAMiY=";

  mypy-boto3-pinpoint-sms-voice =
    buildMypyBoto3Package "pinpoint-sms-voice" "1.35.93"
      "sha256-Re9dSoPNbynA1v8Madvnt3H1LDWpbWICES2UJSGX0cg=";

  mypy-boto3-pinpoint-sms-voice-v2 =
    buildMypyBoto3Package "pinpoint-sms-voice-v2" "1.35.93"
      "sha256-KWth133jbhbmtxjQaxfBI1e4mlgfz2w4O/Uh9cVn7XA=";

  mypy-boto3-pipes =
    buildMypyBoto3Package "pipes" "1.35.93"
      "sha256-HOzP3LzOtAS/WtFwbEd5Zm6UZ/GJal7HGGubTBneHJY=";

  mypy-boto3-polly =
    buildMypyBoto3Package "polly" "1.35.93"
      "sha256-lCUn8gmf1EaLlowOORuuSJj1ARvhIxo1+Fs3cQQZE2Q=";

  mypy-boto3-pricing =
    buildMypyBoto3Package "pricing" "1.35.93"
      "sha256-Dculy8AK9z2lpQbGR0hj5ZgS3Op0Ki06ipzLPfo56fU=";

  mypy-boto3-privatenetworks =
    buildMypyBoto3Package "privatenetworks" "1.35.93"
      "sha256-hcRCSRqPleAs+AGSsXra0R2PGv5kgt0EJFK1XAAEzAg=";

  mypy-boto3-proton =
    buildMypyBoto3Package "proton" "1.35.93"
      "sha256-r751S020bIUMzx9gEyOvWAE0NC64GAhwKpmCtjGVaEQ=";

  mypy-boto3-qldb =
    buildMypyBoto3Package "qldb" "1.35.93"
      "sha256-OifaHQwbSMqCCUbikN+QCmn7da90Vqjx7BM8Y4O8Joc=";

  mypy-boto3-qldb-session =
    buildMypyBoto3Package "qldb-session" "1.35.93"
      "sha256-etDS6vA/+KqGTHNGR254JMsbLyZCbOYX1Qg+E8SgDek=";

  mypy-boto3-quicksight =
    buildMypyBoto3Package "quicksight" "1.35.93"
      "sha256-2L6GCdc2yleyyPGoguO8p4vFEOq4UEgh2TdvokolIGw=";

  mypy-boto3-ram =
    buildMypyBoto3Package "ram" "1.35.93"
      "sha256-7pJ4pqEBiGkuBjYDICH8NRAa19bUOMTDrkLYwQJ454k=";

  mypy-boto3-rbin =
    buildMypyBoto3Package "rbin" "1.35.93"
      "sha256-VECkUIkz/tUtKaiRTpi+gcNYpkI9DugZDFZ13ZjL558=";

  mypy-boto3-rds =
    buildMypyBoto3Package "rds" "1.35.95"
      "sha256-rRukdIPIrpdv4S9+EIndBDp2b4uoWP9cRIV9q1RwL9M=";

  mypy-boto3-rds-data =
    buildMypyBoto3Package "rds-data" "1.35.93"
      "sha256-anaaP4VNdI4ZQWTp/8R6G4APscb6AS5Lo6YRjwbtGFM=";

  mypy-boto3-redshift =
    buildMypyBoto3Package "redshift" "1.35.97"
      "sha256-gJm76sCPgpS9ekNDCmtt68atbVbNh4B8IqO7lS6C3ic=";

  mypy-boto3-redshift-data =
    buildMypyBoto3Package "redshift-data" "1.35.93"
      "sha256-wJujBfiILuGFQc3IkkCTTrf/d9I9cvNmXr5Ioej9fP4=";

  mypy-boto3-redshift-serverless =
    buildMypyBoto3Package "redshift-serverless" "1.35.93"
      "sha256-hAykV/pIoAaJuWYsJnjJWHBLVNY7hLEDDuU6rjiumjM=";

  mypy-boto3-rekognition =
    buildMypyBoto3Package "rekognition" "1.35.93"
      "sha256-WpPJQKxLgWB5JHQIFomYeYNSmn8Pe668r6dLYg0x4t4=";

  mypy-boto3-resiliencehub =
    buildMypyBoto3Package "resiliencehub" "1.35.93"
      "sha256-/1NJ/jj9tBKKXDdFuPEpnQ37+Go1jTlqDqUheoZ47hM=";

  mypy-boto3-resource-explorer-2 =
    buildMypyBoto3Package "resource-explorer-2" "1.35.93"
      "sha256-bHtNXkrVMsL7dAuG+cVYTHVQB/qGf+fSMAAFlFmfakg=";

  mypy-boto3-resource-groups =
    buildMypyBoto3Package "resource-groups" "1.35.93"
      "sha256-tSV6SPU1IhfiLajLmfTDVRXzll6nuHDX9TVh6RHOIcA=";

  mypy-boto3-resourcegroupstaggingapi =
    buildMypyBoto3Package "resourcegroupstaggingapi" "1.35.93"
      "sha256-Te/5hQSgezNq8KQsXQa7kSgGD99Mf2AJg1Kzr5vvYio=";

  mypy-boto3-robomaker =
    buildMypyBoto3Package "robomaker" "1.35.93"
      "sha256-9L+JrNOLXXtzxu5LhtMXd8XqTjSoq3qI0/FSg/CMKus=";

  mypy-boto3-rolesanywhere =
    buildMypyBoto3Package "rolesanywhere" "1.35.93"
      "sha256-Bv1Z2cVGXepn2/VjnoLHozMZvfdfniR+pTzv9FAoXV8=";

  mypy-boto3-route53 =
    buildMypyBoto3Package "route53" "1.35.95"
      "sha256-0Aocwq1wvF7NmODu0NV15IoPEscjb441s0NRTVyi5Hs=";

  mypy-boto3-route53-recovery-cluster =
    buildMypyBoto3Package "route53-recovery-cluster" "1.35.93"
      "sha256-gmgL0S4ePikxVbDWY0gwDYIuskrQcmofMOt8tzXT1Cc=";

  mypy-boto3-route53-recovery-control-config =
    buildMypyBoto3Package "route53-recovery-control-config" "1.35.93"
      "sha256-U26Cw3DOk7CRI3a7iNh7LT3DYypxEfFJEbJNIXL7978=";

  mypy-boto3-route53-recovery-readiness =
    buildMypyBoto3Package "route53-recovery-readiness" "1.35.93"
      "sha256-BLOWLCdDie9My474lQL/4nZNsQFl0rubu/tW0QP5SlU=";

  mypy-boto3-route53domains =
    buildMypyBoto3Package "route53domains" "1.35.93"
      "sha256-BfCQeMhodDX6gOUuLdW/8pjEkqRVe3+eN5v7YeitfUs=";

  mypy-boto3-route53resolver =
    buildMypyBoto3Package "route53resolver" "1.35.93"
      "sha256-hDWJl3j0c31ChU956W2Mh92/c8knt76XM4FEaaXW6N0=";

  mypy-boto3-rum =
    buildMypyBoto3Package "rum" "1.35.93"
      "sha256-X7XTY6cm44l1iaHjIa6KovlGgoGt8GI6MJau7icaSxo=";

  mypy-boto3-s3 =
    buildMypyBoto3Package "s3" "1.35.93"
      "sha256-tFKeV6jV8h1MYf5lD6Z2T+4rp6tSSkVaNLommO9tJ6g=";

  mypy-boto3-s3control =
    buildMypyBoto3Package "s3control" "1.35.93"
      "sha256-WDeCt9cCtuwuqoPg2LhYsbmlkw0njOn2RM+9UmGyCF4=";

  mypy-boto3-s3outposts =
    buildMypyBoto3Package "s3outposts" "1.35.93"
      "sha256-nuCuzwEQnTMuI8Wd1an+vT3fsUAgpHqIRyoXV66L4Xs=";

  mypy-boto3-sagemaker =
    buildMypyBoto3Package "sagemaker" "1.35.95"
      "sha256-hJfmA6R/to1JQW/VIi71LoJ6gIhXboZFMtxxZnVtX9A=";

  mypy-boto3-sagemaker-a2i-runtime =
    buildMypyBoto3Package "sagemaker-a2i-runtime" "1.35.93"
      "sha256-DNQI7lT96SVWT1wmJRieDbQyWFgqvKfF8fgRbxC4qx4=";

  mypy-boto3-sagemaker-edge =
    buildMypyBoto3Package "sagemaker-edge" "1.35.93"
      "sha256-wl992aZhyfUKNe1XKXinnbOdelgkNRtTfnVrCOtUUtI=";

  mypy-boto3-sagemaker-featurestore-runtime =
    buildMypyBoto3Package "sagemaker-featurestore-runtime" "1.35.93"
      "sha256-Wpx/JFjjNQe1FJvfzzsfU0A6CGUubVqTHwpYxOV3ZcU=";

  mypy-boto3-sagemaker-geospatial =
    buildMypyBoto3Package "sagemaker-geospatial" "1.35.93"
      "sha256-+hUBSCDJBca1EvfsqvFUg4nvG1MUkEEwI2jB/WTIw9Q=";

  mypy-boto3-sagemaker-metrics =
    buildMypyBoto3Package "sagemaker-metrics" "1.35.93"
      "sha256-jwEZ+8Ixlgdv4uG5pQX9lGRbtGWZQzG2ZthnzC4j5m4=";

  mypy-boto3-sagemaker-runtime =
    buildMypyBoto3Package "sagemaker-runtime" "1.35.93"
      "sha256-T9lf0Iq/OF1VP4H90Ji1+NvSoBBntE5L7oBocQFXil4=";

  mypy-boto3-savingsplans =
    buildMypyBoto3Package "savingsplans" "1.35.93"
      "sha256-k7AAzABY15Lkz7NdPCQtIpiGzRQlDEUyPj59ypwTNqw=";

  mypy-boto3-scheduler =
    buildMypyBoto3Package "scheduler" "1.35.93"
      "sha256-Ahs2c/f8nkuLNE07xkAHRH2ZOlNr0iRGXZJ+Lm2Vkrk=";

  mypy-boto3-schemas =
    buildMypyBoto3Package "schemas" "1.35.93"
      "sha256-fyJV3dbVMRAexn+9GvyovgJWj05Xh9FjEZmqJbWKSA8=";

  mypy-boto3-sdb =
    buildMypyBoto3Package "sdb" "1.35.93"
      "sha256-quvoYvLCckS/EQmtobhl2Mq66fT/HMuXaSvt3Urpn+o=";

  mypy-boto3-secretsmanager =
    buildMypyBoto3Package "secretsmanager" "1.35.93"
      "sha256-tsS8iKX+QUMSQnJyjUE0LgHHeLQG251keiDa0N59b0c=";

  mypy-boto3-securityhub =
    buildMypyBoto3Package "securityhub" "1.35.93"
      "sha256-2kPOD5J5TK+vQbQVFfK9z68uTeXL62sj1Jqe2CuB4sw=";

  mypy-boto3-securitylake =
    buildMypyBoto3Package "securitylake" "1.35.97"
      "sha256-m+cjupsQESwFSTcWE6JwIG6Pyx9kri4GwJyjXLlLdos=";

  mypy-boto3-serverlessrepo =
    buildMypyBoto3Package "serverlessrepo" "1.35.93"
      "sha256-x+9kE7sxdzO8VVAuGbNjZmxxb6Nt/SyqgNRRTvYYaWk=";

  mypy-boto3-service-quotas =
    buildMypyBoto3Package "service-quotas" "1.35.93"
      "sha256-oygm05PIsP8VoC1QfxSxrTq+gHBeisHM/P9P74zBSWg=";

  mypy-boto3-servicecatalog =
    buildMypyBoto3Package "servicecatalog" "1.35.93"
      "sha256-BG2ZeYpBK5a15/9jahyAwNOsyqIO5JGSjF/PdrKk62Y=";

  mypy-boto3-servicecatalog-appregistry =
    buildMypyBoto3Package "servicecatalog-appregistry" "1.35.93"
      "sha256-/w9aPilkpAEDpGhiTErGE/syPmpJJZYI9Jc+CMS9+HY=";

  mypy-boto3-servicediscovery =
    buildMypyBoto3Package "servicediscovery" "1.35.93"
      "sha256-nJ3uWIw+e0xgPrCe8beTbIWsHPrzAZdftSa1E1f3x0o=";

  mypy-boto3-ses =
    buildMypyBoto3Package "ses" "1.35.93"
      "sha256-e9gUg2aVvJyp+OMdMM8U6AkeK7NcHZGJNCmXT/2ryt8=";

  mypy-boto3-sesv2 =
    buildMypyBoto3Package "sesv2" "1.35.93"
      "sha256-FpYJkBZJ1LqisdHjougk8ECVln9d1nC4J1EBbA4/Pss=";

  mypy-boto3-shield =
    buildMypyBoto3Package "shield" "1.35.93"
      "sha256-JFsmQeD55cdfMQPkJ9ce/47qKA/4wp4Rz9dQIuXQyEg=";

  mypy-boto3-signer =
    buildMypyBoto3Package "signer" "1.35.93"
      "sha256-8Sx8cCXMJYBBRkMfY58+udtmSkaVvyjSqH9YER/H+Ig=";

  mypy-boto3-simspaceweaver =
    buildMypyBoto3Package "simspaceweaver" "1.35.93"
      "sha256-i22F+tgnVc+sV3fU1KqDtxzAzXJKYQneCEXXqL9mxmM=";

  mypy-boto3-sms =
    buildMypyBoto3Package "sms" "1.35.93"
      "sha256-ImW9UPfUaxI7fX3GrQxveOcXBUDrtFtHt+OSe4V3Vac=";

  mypy-boto3-sms-voice =
    buildMypyBoto3Package "sms-voice" "1.35.93"
      "sha256-uUSq50+ythj9GGwZ9sIhzf77aZseaJ/v5eopLC8eysg=";

  mypy-boto3-snow-device-management =
    buildMypyBoto3Package "snow-device-management" "1.35.93"
      "sha256-6o8xYbbWYH1rgTaJN1Wb1FctadM4ytuwZ71E6D4VT3s=";

  mypy-boto3-snowball =
    buildMypyBoto3Package "snowball" "1.35.93"
      "sha256-LNDqr4uQ/rwxGb33B39stWYq6ZKPXCRmifvUW0ReCjk=";

  mypy-boto3-sns =
    buildMypyBoto3Package "sns" "1.35.93"
      "sha256-/RfOxBC8R3CWZSQx0ySIH00zuJ+rfEyFfzNHRCNU/6E=";

  mypy-boto3-sqs =
    buildMypyBoto3Package "sqs" "1.35.93"
      "sha256-jqf2Pgh4VEcFwxmWrkwGQJX7tPeA+DI6hPenUoHWQ/4=";

  mypy-boto3-ssm =
    buildMypyBoto3Package "ssm" "1.35.93"
      "sha256-LiYQ4zykoHVZXTD6Bh7y5Uydm2ztFKGWMW3NAyNy3Yw=";

  mypy-boto3-ssm-contacts =
    buildMypyBoto3Package "ssm-contacts" "1.35.93"
      "sha256-l9THTO4MuUJ2xHfwNJI7ZNJzFoML/FQcXFNPv7b52lU=";

  mypy-boto3-ssm-incidents =
    buildMypyBoto3Package "ssm-incidents" "1.35.93"
      "sha256-2XKhNEnaewx9jnmO1BOoLcB7uL5oYuFS7sFUZSuXpBY=";

  mypy-boto3-ssm-sap =
    buildMypyBoto3Package "ssm-sap" "1.35.93"
      "sha256-zkdyRuqCD3tWGhiG2QLLcMZCLFo2FZP5NJR/MFIOf/8=";

  mypy-boto3-sso =
    buildMypyBoto3Package "sso" "1.35.93"
      "sha256-EscnxBkFNP9A2a9efKnTFxqFDOBSCVANMnEpMx9kX5c=";

  mypy-boto3-sso-admin =
    buildMypyBoto3Package "sso-admin" "1.35.93"
      "sha256-sO4y6IiUYgJ+gegh0eLZYxZRtMrH1VhiN3AwaTZlz/4=";

  mypy-boto3-sso-oidc =
    buildMypyBoto3Package "sso-oidc" "1.35.93"
      "sha256-01StpINYr2kMrQomcwtTBUp05n75A5u1374147MIOho=";

  mypy-boto3-stepfunctions =
    buildMypyBoto3Package "stepfunctions" "1.35.93"
      "sha256-ICMGFcQuequ9Q7YmV8o1NOlnZyRXBdEtQmcqyHzRtZw=";

  mypy-boto3-storagegateway =
    buildMypyBoto3Package "storagegateway" "1.35.93"
      "sha256-HVi4ZB2gqc1Y+yTrQagG0JgtMsMoASoLrHlLCZA7GUE=";

  mypy-boto3-sts =
    buildMypyBoto3Package "sts" "1.35.97"
      "sha256-bfaY9qQAqC68wvEK20NVf2YnhGcgDg91WI594+ShYi0=";

  mypy-boto3-support =
    buildMypyBoto3Package "support" "1.35.93"
      "sha256-VLuoFBRVQGQjmBGkGLckHoZ8BGxsYAaWw7478+E30kI=";

  mypy-boto3-support-app =
    buildMypyBoto3Package "support-app" "1.35.93"
      "sha256-heFS9aPrKcyj84Gpv3nYulazL6t0rMmz2nB+Q7PS4Ss=";

  mypy-boto3-swf =
    buildMypyBoto3Package "swf" "1.35.93"
      "sha256-vH7xRcl48167KKfnFxW2TZYX/pm8M2q95WQnNxxMMg0=";

  mypy-boto3-synthetics =
    buildMypyBoto3Package "synthetics" "1.35.93"
      "sha256-fh9SKirxWLLDvNMrAu0a4ARkTg5shWxqg3rtopwsXbg=";

  mypy-boto3-textract =
    buildMypyBoto3Package "textract" "1.35.93"
      "sha256-EUqFj2p6JASmJ1mqwGJEzgNc91CwtniWQSDGLwa3Jcw=";

  mypy-boto3-timestream-query =
    buildMypyBoto3Package "timestream-query" "1.35.93"
      "sha256-oIIG9J/f2hq7mOhg7InRW8bziS9YIzu07KE9Ib7Vntw=";

  mypy-boto3-timestream-write =
    buildMypyBoto3Package "timestream-write" "1.35.93"
      "sha256-KmpRkcdgbIIu3izY43aGm37jO46ZqGGA/6oNEEWOcOg=";

  mypy-boto3-tnb =
    buildMypyBoto3Package "tnb" "1.35.93"
      "sha256-bTp/f0/MyQz4ThQoKWmPZRHF640/tCGyXOUQKGOqkuc=";

  mypy-boto3-transcribe =
    buildMypyBoto3Package "transcribe" "1.35.98"
      "sha256-6yZCljyU/Gi2+PI3B4//EHaaomIFREwG6N15py1SVCs=";

  mypy-boto3-transfer =
    buildMypyBoto3Package "transfer" "1.35.93"
      "sha256-M5t2l9lKR96LL1foB87vNIsEk3bCJ5sDaKZG0C7lmGM=";

  mypy-boto3-translate =
    buildMypyBoto3Package "translate" "1.35.93"
      "sha256-uXRM1S6zGbLNvCx342Nh4GPeZXVBRYpxDO0FFsRwYgc=";

  mypy-boto3-verifiedpermissions =
    buildMypyBoto3Package "verifiedpermissions" "1.35.93"
      "sha256-e9C5tky3SXyj9mPj6QGFCazGCwRJOCGd1qsT/5iGHqc=";

  mypy-boto3-voice-id =
    buildMypyBoto3Package "voice-id" "1.35.93"
      "sha256-prmsprO29LGCnnRKWpdzAYJniSK5uB0LQVxRmHie1MA=";

  mypy-boto3-vpc-lattice =
    buildMypyBoto3Package "vpc-lattice" "1.35.93"
      "sha256-UDmaLRzKgC/HcF/F/LgVSHhJnJbHINWWObGZCYL3leE=";

  mypy-boto3-waf =
    buildMypyBoto3Package "waf" "1.35.93"
      "sha256-lHkEYsRyG5GwsMYPuymL6Ltt1R+Ujy+IgqNdLAzC9PU=";

  mypy-boto3-waf-regional =
    buildMypyBoto3Package "waf-regional" "1.35.93"
      "sha256-cLT0vTVvBBl7eKvJ/KWWv4bb4gZQpThmcKxk+w8Pbrc=";

  mypy-boto3-wafv2 =
    buildMypyBoto3Package "wafv2" "1.35.93"
      "sha256-HupEyARSEl2rObgpAzvNtm+Gwg+hktsVWMVa/TxSgHI=";

  mypy-boto3-wellarchitected =
    buildMypyBoto3Package "wellarchitected" "1.35.93"
      "sha256-tnMdjJDmJEvBbV97l/LkLYYEZD06QOcy4VSWxO1+KLM=";

  mypy-boto3-wisdom =
    buildMypyBoto3Package "wisdom" "1.35.93"
      "sha256-ejAwfOXU/m5IKmJwHMN8GX394ZFq89GU1i3HAtoNjN4=";

  mypy-boto3-workdocs =
    buildMypyBoto3Package "workdocs" "1.35.93"
      "sha256-AMnvm/ZUy6myNgq26H19HJwpJLhUAYG6Hs1g71u45SI=";

  mypy-boto3-worklink =
    buildMypyBoto3Package "worklink" "1.35.0"
      "sha256-AgK4Xg1dloJmA+h4+mcBQQVTvYKjLCk5tPDbl/ItCVQ=";

  mypy-boto3-workmail =
    buildMypyBoto3Package "workmail" "1.35.93"
      "sha256-52pwdGTl6HBcW07z1hmlSG4ExiKRju87pR8iGm3Q1yU=";

  mypy-boto3-workmailmessageflow =
    buildMypyBoto3Package "workmailmessageflow" "1.35.93"
      "sha256-84xq90JaVbLxjvgNL0ZA0aVQSm8zjR7Fh7sslGAZztk=";

  mypy-boto3-workspaces =
    buildMypyBoto3Package "workspaces" "1.35.93"
      "sha256-lGKzDHP59Czm/+e4SPzIa6zkvm728OpT6JtauNktvek=";

  mypy-boto3-workspaces-web =
    buildMypyBoto3Package "workspaces-web" "1.35.93"
      "sha256-Uk3/3CmIhlonNmnTkV8TBsvWDosRvXdFJRR3CpowTJc=";

  mypy-boto3-xray =
    buildMypyBoto3Package "xray" "1.35.93"
      "sha256-fgr5R08G2hkjqjfIY5sFEELMOlbRo2sBQRJNnee+Zwk=";
}
