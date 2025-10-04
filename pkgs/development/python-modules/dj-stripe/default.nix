{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  django,
  stripe,
  mysqlclient,
  psycopg2,
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dj-stripe";
  version = "2.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dj-stripe";
    repo = "dj-stripe";
    tag = version;
    hash = "sha256-ijTzSid5B79mAi7qUFSGL5+4PfmBStDWayzjW1iwRww=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    django
    stripe
  ];

  passthru.optional-dependencies = {
    mysql = [ mysqlclient ];
    postgres = [ psycopg2 ];
  };

  env = {
    DJANGO_SETTINGS_MODULE = "tests.settings";
    DJSTRIPE_TEST_DB_VENDOR = "sqlite";
  };

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  disabledTestPaths = [
    "tests/test_customer.py::TestCustomer::test_customer_sync_unsupported_source"
    "tests/test_customer.py::TestCustomer::test_upcoming_invoice_plan"
    "tests/test_customer.py::TestCustomerLegacy::test_upcoming_invoice"
    "tests/test_event_handlers.py::TestCustomerEvents::test_customer_default_source_deleted"
    "tests/test_event_handlers.py::TestCustomerEvents::test_customer_deleted"
    "tests/test_event_handlers.py::TestCustomerEvents::test_customer_source_double_delete"
    "tests/test_event_handlers.py::TestPlanEvents::test_plan_created"
    "tests/test_event_handlers.py::TestPlanEvents::test_plan_deleted"
    "tests/test_event_handlers.py::TestPlanEvents::test_plan_updated_request_object"
    "tests/test_event_handlers.py::TestTaxIdEvents::test_tax_id_created"
    "tests/test_event_handlers.py::TestTaxIdEvents::test_tax_id_deleted"
    "tests/test_event_handlers.py::TestTaxIdEvents::test_tax_id_updated"
    "tests/test_invoice.py::InvoiceTest::test_upcoming_invoice"
    "tests/test_invoice.py::InvoiceTest::test_upcoming_invoice_with_subscription"
    "tests/test_invoice.py::InvoiceTest::test_upcoming_invoice_with_subscription_plan"
    "tests/test_invoice.py::TestInvoiceDecimal::test_decimal_tax_percent"
    "tests/test_plan.py::PlanCreateTest::test_create_from_djstripe_product"
    "tests/test_plan.py::PlanCreateTest::test_create_from_product_id"
    "tests/test_plan.py::PlanCreateTest::test_create_from_stripe_product"
    "tests/test_plan.py::PlanCreateTest::test_create_with_metadata"
    "tests/test_price.py::PriceCreateTest::test_create_from_djstripe_product"
    "tests/test_price.py::PriceCreateTest::test_create_from_product_id"
    "tests/test_price.py::PriceCreateTest::test_create_from_stripe_product"
    "tests/test_price.py::PriceCreateTest::test_create_with_metadata"
    "tests/test_settings.py::TestSubscriberModelRetrievalMethod::test_bad_callback"
    "tests/test_settings.py::TestSubscriberModelRetrievalMethod::test_no_callback"
    "tests/test_settings.py::TestStripeApiVersion::test_global_stripe_api_version"
    "tests/test_subscription.py::TestSubscriptionDecimal::test_decimal_application_fee_percent"
    "tests/test_tax_id.py::TestTaxIdStr::test___str__"
    "tests/test_tax_id.py::TestTransfer::test__api_create"
    "tests/test_tax_id.py::TestTransfer::test__api_create_no_customer"
    "tests/test_tax_id.py::TestTransfer::test__api_create_no_id_kwarg"
    "tests/test_tax_id.py::TestTransfer::test_api_list"
    "tests/test_tax_id.py::TestTransfer::test_api_retrieve"
    "tests/test_tax_rates.py::TestTaxRateDecimal::test_decimal_tax_percent"
    "tests/test_transfer_reversal.py::TestTransfer::test_api_list"
    "tests/test_transfer_reversal.py::TestTransfer::test_api_retrieve"
    "tests/test_usage_record.py::TestUsageRecord::test___str__"
    "tests/test_usage_record.py::TestUsageRecord::test__api_create"
    "tests/test_usage_record_summary.py::TestUsageRecordSummary::test___str__"
    "tests/test_usage_record_summary.py::TestUsageRecordSummary::test_api_list"
    "tests/test_usage_record_summary.py::TestUsageRecordSummary::test_sync_from_stripe_data"
    "tests/test_views.py::TestConfirmCustomActionView::test__cancel_subscription_instances_stripe_invalid_request_error"
    "tests/test_views.py::TestConfirmCustomActionView::test__release_subscription_schedule_stripe_invalid_request_error"
    "tests/test_views.py::TestConfirmCustomActionView::test__cancel_subscription_schedule_stripe_invalid_request_error"
    "tests/test_webhooks.py::TestWebhookEventTrigger::test___str__"
    "tests/test_webhooks.py::TestWebhookEventTrigger::test_webhook_error"
    "tests/test_webhooks.py::TestWebhookEventTrigger::test_webhook_good_connect_account"
    "tests/test_webhooks.py::TestWebhookEventTrigger::test_webhook_good_platform_account"
    "tests/test_webhooks.py::TestWebhookEventTrigger::test_webhook_invalid_verify_signature_fail"
    "tests/test_webhooks.py::TestWebhookEventTrigger::test_webhook_no_signature"
    "tests/test_webhooks.py::TestWebhookEventTrigger::test_webhook_no_validation_pass"
    "tests/test_webhooks.py::TestWebhookEventTrigger::test_webhook_remote_addr_is_empty_string"
    "tests/test_webhooks.py::TestWebhookEventTrigger::test_webhook_remote_addr_is_none"
    "tests/test_webhooks.py::TestWebhookEventTrigger::test_webhook_reraise_exception"
    "tests/test_webhooks.py::TestWebhookEventTrigger::test_webhook_retrieve_event_fail"
    "tests/test_webhooks.py::TestWebhookEventTrigger::test_webhook_retrieve_event_pass"
    "tests/test_webhooks.py::TestWebhookEventTrigger::test_webhook_test_event"
    "tests/test_webhooks.py::TestWebhookEventTrigger::test_webhook_verify_signature_pass"
    "tests/test_webhooks.py::TestWebhookEventTrigger::test_webhook_with_custom_callback"
    "tests/test_webhooks.py::TestWebhookEventTrigger::test_webhook_with_transfer_event_duplicate"
    "tests/test_webhooks.py::TestGetRemoteIp::test_get_remote_ip_remote_addr_is_none"
  ];

  pythonImportsCheck = [ "djstripe" ];

  meta = {
    description = "Stripe Models for Django";
    homepage = "https://github.com/dj-stripe/dj-stripe";
    changelog = "https://github.com/dj-stripe/dj-stripe/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
  };
}
