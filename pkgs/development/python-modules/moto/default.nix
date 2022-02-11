{ lib, buildPythonPackage, fetchPypi, isPy27, fetchpatch
, aws-xray-sdk
, backports_tempfile
, boto3
, botocore
, cfn-lint
, docker
, flask
, flask-cors
, freezegun
, jinja2
, jsondiff
, mock
, pyaml
, python-jose
, pytz
, requests
, responses
, six
, sshpubkeys
, sure
, werkzeug
, xmltodict
, parameterized
, idna
, nose
, pytestCheckHook
, pytest-xdist
}:

buildPythonPackage rec {
  pname = "moto";
  version = "3.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-vZ1oofOYUkFETDFKwSmifvvn+bCi/6NQAxu950NYk5k=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "ecdsa<0.15" "ecdsa" \
      --replace "idna<3,>=2.5" "idna" \
      --replace "MarkupSafe<2.0" "MarkupSafe" \
  '';

  propagatedBuildInputs = [
    aws-xray-sdk
    boto3
    botocore
    cfn-lint
    docker
    flask # required for server
    jinja2
    jsondiff
    mock
    pyaml
    python-jose
    pytz
    six
    requests
    responses
    sshpubkeys
    werkzeug
    xmltodict
    idna
  ] ++ lib.optionals isPy27 [ backports_tempfile ];

  checkInputs = [
    boto3
    flask-cors
    freezegun
    parameterized
    pytestCheckHook
    pytest-xdist
    sure
  ];

  # Multiple test files still import boto, rather than boto3 like
  # boto is long-deprecated and broken on python3.9
  # https://github.com/spulec/moto/blob/63ce647123755e4c4693a89f52c254596004c098/tests/test_autoscaling/test_autoscaling.py#L2
  # NOTE: This should change to use disabledTestFiles / disabledTestPaths once that
  # feature stabalizes: see #113153 (mostly the discussion therein), #113167, #110700
  pytestFlagsArray = [
    "-n $NIX_BUILD_CORES"
    "--ignore=tests/test_awslambda/test_policy.py"
    "--ignore=tests/test_autoscaling/test_autoscaling.py"
    "--ignore=tests/test_autoscaling/test_cloudformation.py"
    "--ignore=tests/test_autoscaling/test_elbv2.py"
    "--ignore=tests/test_autoscaling/test_launch_configurations.py"
    "--ignore=tests/test_autoscaling/test_policies.py"
    "--ignore=tests/test_autoscaling/test_server.py"
    "--ignore=tests/test_awslambda/test_lambda.py"
    "--ignore=tests/test_awslambda/test_lambda_cloudformation.py"
    "--ignore=tests/test_batch/test_cloudformation.py"
    "--ignore=tests/test_batch/test_server.py"
    "--ignore=tests/test_cloudformation/test_cloudformation_depends_on.py"
    "--ignore=tests/test_cloudformation/test_cloudformation_stack_crud.py"
    "--ignore=tests/test_cloudformation/test_cloudformation_stack_crud_boto3.py"
    "--ignore=tests/test_cloudformation/test_cloudformation_stack_integration.py"
    "--ignore=tests/test_cloudformation/test_stack_parsing.py"
    "--ignore=tests/test_cloudformation/test_validate.py"
    "--ignore=tests/test_cloudwatch/test_cloudwatch.py"
    "--ignore=tests/test_cognitoidentity/test_server.py"
    "--ignore=tests/test_config/test_config.py"
    "--ignore=tests/test_core/test_auth.py"
    "--ignore=tests/test_core/test_decorator_calls.py"
    "--ignore=tests/test_core/test_nested.py"
    "--ignore=tests/test_core/test_server.py"
    "--ignore=tests/test_datapipeline/test_datapipeline.py"
    "--ignore=tests/test_datapipeline/test_server.py"
    "--ignore=tests/test_datasync/test_datasync.py"
    "--ignore=tests/test_dynamodb/test_dynamodb.py"
    "--ignore=tests/test_dynamodb/test_dynamodb_table_with_range_key.py"
    "--ignore=tests/test_dynamodb/test_dynamodb_table_without_range_key.py"
    "--ignore=tests/test_dynamodb/test_server.py"
    "--ignore=tests/test_dynamodb2/test_dynamodb.py"
    "--ignore=tests/test_dynamodb2/test_dynamodb_table_with_range_key.py"
    "--ignore=tests/test_dynamodb2/test_dynamodb_table_without_range_key.py"
    "--ignore=tests/test_dynamodb2/test_server.py"
    "--ignore=tests/test_ec2/test_amazon_dev_pay.py"
    "--ignore=tests/test_ec2/test_amis.py"
    "--ignore=tests/test_ec2/test_availability_zones_and_regions.py"
    "--ignore=tests/test_ec2/test_customer_gateways.py"
    "--ignore=tests/test_ec2/test_dhcp_options.py"
    "--ignore=tests/test_ec2/test_elastic_block_store.py"
    "--ignore=tests/test_ec2/test_elastic_ip_addresses.py"
    "--ignore=tests/test_ec2/test_elastic_network_interfaces.py"
    "--ignore=tests/test_ec2/test_general.py"
    "--ignore=tests/test_ec2/test_instances.py"
    "--ignore=tests/test_ec2/test_internet_gateways.py"
    "--ignore=tests/test_ec2/test_ip_addresses.py"
    "--ignore=tests/test_ec2/test_key_pairs.py"
    "--ignore=tests/test_ec2/test_monitoring.py"
    "--ignore=tests/test_ec2/test_network_acls.py"
    "--ignore=tests/test_ec2/test_placement_groups.py"
    "--ignore=tests/test_ec2/test_regions.py"
    "--ignore=tests/test_ec2/test_reserved_instances.py"
    "--ignore=tests/test_ec2/test_route_tables.py"
    "--ignore=tests/test_ec2/test_security_groups.py"
    "--ignore=tests/test_ec2/test_spot_instances.py"
    "--ignore=tests/test_ec2/test_subnets.py"
    "--ignore=tests/test_ec2/test_tags.py"
    "--ignore=tests/test_ec2/test_virtual_private_gateways.py"
    "--ignore=tests/test_ec2/test_vm_export.py"
    "--ignore=tests/test_ec2/test_vm_import.py"
    "--ignore=tests/test_ec2/test_vpc_peering.py"
    "--ignore=tests/test_ec2/test_vpcs.py"
    "--ignore=tests/test_ec2/test_vpn_connections.py"
    "--ignore=tests/test_ec2/test_vpn_connections.py"
    "--ignore=tests/test_ec2/test_windows.py"
    "--ignore=tests/test_ecs/test_ecs_boto3.py"
    "--ignore=tests/test_elb/test_elb.py"
    "--ignore=tests/test_elb/test_server.py"
    "--ignore=tests/test_elbv2/test_elbv2.py"
    "--ignore=tests/test_elbv2/test_server.py"
    "--ignore=tests/test_emr/test_emr.py"
    "--ignore=tests/test_emr/test_server.py"
    "--ignore=tests/test_glacier/test_glacier_archives.py"
    "--ignore=tests/test_glacier/test_glacier_jobs.py"
    "--ignore=tests/test_glacier/test_glacier_vaults.py"
    "--ignore=tests/test_iam/test_iam.py"
    "--ignore=tests/test_iam/test_iam_cloudformation.py"
    "--ignore=tests/test_iam/test_iam_groups.py"
    "--ignore=tests/test_iam/test_server.py"
    "--ignore=tests/test_iot/test_server.py"
    "--ignore=tests/test_iotdata/test_server.py"
    "--ignore=tests/test_kinesis/test_kinesis.py"
    "--ignore=tests/test_kinesis/test_kinesis_cloudformation.py"
    "--ignore=tests/test_kinesis/test_server.py"
    "--ignore=tests/test_kinesisvideo/test_server.py"
    "--ignore=tests/test_kinesisvideoarchivedmedia/test_server.py"
    "--ignore=tests/test_kms/test_kms.py"
    "--ignore=tests/test_kms/test_server.py"
    "--ignore=tests/test_kms/test_utils.py"
    "--ignore=tests/test_logs/test_logs.py"
    "--ignore=tests/test_polly/test_server.py"
    "--ignore=tests/test_rds/test_rds.py"
    "--ignore=tests/test_rds/test_server.py"
    "--ignore=tests/test_rds2/test_server.py"
    "--ignore=tests/test_redshift/test_redshift.py"
    "--ignore=tests/test_redshift/test_server.py"
    "--ignore=tests/test_resourcegroupstaggingapi/test_resourcegroupstaggingapi.py"
    "--ignore=tests/test_route53/test_route53.py"
    "--ignore=tests/test_s3/test_s3.py"
    "--ignore=tests/test_s3/test_s3_cloudformation.py"
    "--ignore=tests/test_s3/test_s3_lifecycle.py"
    "--ignore=tests/test_s3/test_s3_storageclass.py"
    "--ignore=tests/test_s3/test_s3_utils.py"
    "--ignore=tests/test_s3bucket_path/test_s3bucket_path.py"
    "--ignore=tests/test_s3bucket_path/test_s3bucket_path_combo.py"
    "--ignore=tests/test_secretsmanager/test_server.py"
    "--ignore=tests/test_ses/test_server.py"
    "--ignore=tests/test_ses/test_ses.py"
    "--ignore=tests/test_ses/test_ses_boto3.py"
    "--ignore=tests/test_ses/test_ses_sns_boto3.py"
    "--ignore=tests/test_sns/test_application.py"
    "--ignore=tests/test_sns/test_application_boto3.py"
    "--ignore=tests/test_sns/test_publishing.py"
    "--ignore=tests/test_sns/test_publishing_boto3.py"
    "--ignore=tests/test_sns/test_server.py"
    "--ignore=tests/test_sns/test_subscriptions.py"
    "--ignore=tests/test_sns/test_subscriptions_boto3.py"
    "--ignore=tests/test_sns/test_topics.py"
    "--ignore=tests/test_sns/test_topics_boto3.py"
    "--ignore=tests/test_sqs/test_server.py"
    "--ignore=tests/test_sqs/test_sqs.py"
    "--ignore=tests/test_ssm/test_ssm_boto3.py"
    "--ignore=tests/test_ssm/test_ssm_docs.py"
    "--ignore=tests/test_sts/test_server.py"
    "--ignore=tests/test_sts/test_sts.py"
    "--ignore=tests/test_swf/models/test_activity_task.py"
    "--ignore=tests/test_swf/models/test_decision_task.py"
    "--ignore=tests/test_swf/models/test_timeout.py"
    "--ignore=tests/test_swf/models/test_workflow_execution.py"
    "--ignore=tests/test_swf/responses/test_activity_tasks.py"
    "--ignore=tests/test_swf/responses/test_activity_types.py"
    "--ignore=tests/test_swf/responses/test_decision_tasks.py"
    "--ignore=tests/test_swf/responses/test_domains.py"
    "--ignore=tests/test_swf/responses/test_timeouts.py"
    "--ignore=tests/test_swf/responses/test_workflow_executions.py"
    "--ignore=tests/test_swf/responses/test_workflow_types.py"
    # attempts web connections
    "--ignore=tests/test_appsync/test_appsync_schema.py"
    "--ignore=tests/test_awslambda/test_lambda_eventsourcemapping.py"
    "--ignore=tests/test_awslambda/test_lambda_invoke.py"
    "--ignore=tests/test_batch/test_batch_jobs.py"
    "--ignore=tests/**/*_integration.py"
  ];

  disabledTests = [
    # these tests rely on the network
    "test_server"
    "test_managedblockchain_nodes"
    "test_swf"
    "test_simple_instance"
    "test_passthrough_requests"
    "test_s3_server_get"
    "test_s3_server_bucket_create"
    "test_s3_server_post_to_bucket"
    "test_s3_server_put_ipv6"
    "test_s3_server_put_ipv4"
    "test_http_proxying_integration"
    "test_submit_job_by_name"
    "test_submit_job"
    "test_list_jobs"
    "test_terminate_job"
    "test_idtoken_contains_kid_header"
    "test_latest_meta_data"
    "test_meta_data_iam"
    "test_meta_data_security_credentials"
    "test_meta_data_default_role"
    "test_reset_api"
    "test_data_api"
    "test_requests_to_amazon_subdomains_dont_work"
    "test_get_records_seq"
    "test_stream_with_range_key"
    "test_create_notebook_instance_bad_volume_size"
    "http_destination"
    "test_invoke_function_from_sqs_exception"
    "test_state_machine_list_executions_with_pagination"
    "test_put_subscription_filter_with_lambda"
    "test_create_custom_lambda_resource__verify_cfnresponse_failed"
    "test_state_machine_creation_fails_with_invalid_names"
    # needs graphql
    "test_get_schema_creation_status"
  ];

  meta = with lib; {
    description = "Allows your tests to easily mock out AWS Services";
    homepage = "https://github.com/spulec/moto";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
