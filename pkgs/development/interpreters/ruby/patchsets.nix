{ patchSet, useRailsExpress, ops, patchLevel }:

rec {
  "1.9.3" = [
    ./ssl_v3.patch
    ./ruby19-parallel-install.patch
    ./bitperfect-rdoc.patch
  ] ++ ops useRailsExpress [
    "${patchSet}/patches/ruby/1.9.3/p${patchLevel}/railsexpress/01-fix-make-clean.patch"
    "${patchSet}/patches/ruby/1.9.3/p${patchLevel}/railsexpress/02-zero-broken-tests.patch"
    "${patchSet}/patches/ruby/1.9.3/p${patchLevel}/railsexpress/03-railsbench-gc.patch"
    "${patchSet}/patches/ruby/1.9.3/p${patchLevel}/railsexpress/04-display-more-detailed-stack-trace.patch"
    "${patchSet}/patches/ruby/1.9.3/p${patchLevel}/railsexpress/05-fork-support-for-gc-logging.patch"
    "${patchSet}/patches/ruby/1.9.3/p${patchLevel}/railsexpress/06-track-live-dataset-size.patch"
    "${patchSet}/patches/ruby/1.9.3/p${patchLevel}/railsexpress/07-webrick_204_304_keep_alive_fix.patch"
    "${patchSet}/patches/ruby/1.9.3/p${patchLevel}/railsexpress/08-export-a-few-more-symbols-for-ruby-prof.patch"
    "${patchSet}/patches/ruby/1.9.3/p${patchLevel}/railsexpress/09-thread-variables.patch"
    "${patchSet}/patches/ruby/1.9.3/p${patchLevel}/railsexpress/10-faster-loading.patch"
    "${patchSet}/patches/ruby/1.9.3/p${patchLevel}/railsexpress/11-falcon-st-opt.patch"
    "${patchSet}/patches/ruby/1.9.3/p${patchLevel}/railsexpress/12-falcon-sparse-array.patch"
    "${patchSet}/patches/ruby/1.9.3/p${patchLevel}/railsexpress/13-falcon-array-queue.patch"
    "${patchSet}/patches/ruby/1.9.3/p${patchLevel}/railsexpress/14-railsbench-gc-fixes.patch"
    "${patchSet}/patches/ruby/1.9.3/p${patchLevel}/railsexpress/15-show-full-backtrace-on-stack-overflow.patch"
    "${patchSet}/patches/ruby/1.9.3/p${patchLevel}/railsexpress/16-configurable-fiber-stack-sizes.patch"
    "${patchSet}/patches/ruby/1.9.3/p${patchLevel}/railsexpress/17-backport-psych-20.patch"
    "${patchSet}/patches/ruby/1.9.3/p${patchLevel}/railsexpress/18-fix-missing-c-return-event.patch"
    "${patchSet}/patches/ruby/1.9.3/p${patchLevel}/railsexpress/19-fix-process-daemon-call.patch"
  ];
  "2.0.0" = [
    ./ssl_v3.patch
  ] ++ ops useRailsExpress [
    "${patchSet}/patches/ruby/2.0.0/p${patchLevel}/railsexpress/01-zero-broken-tests.patch"
    "${patchSet}/patches/ruby/2.0.0/p${patchLevel}/railsexpress/02-railsexpress-gc.patch"
    "${patchSet}/patches/ruby/2.0.0/p${patchLevel}/railsexpress/03-display-more-detailed-stack-trace.patch"
    "${patchSet}/patches/ruby/2.0.0/p${patchLevel}/railsexpress/04-show-full-backtrace-on-stack-overflow.patch"
  ];
  "2.1.0" = [
    ./ssl_v3.patch
  ] ++ ops useRailsExpress [
    "${patchSet}/patches/ruby/2.1.0/railsexpress/01-current-2.1.1-fixes.patch"
    "${patchSet}/patches/ruby/2.1.0/railsexpress/02-zero-broken-tests.patch"
    "${patchSet}/patches/ruby/2.1.0/railsexpress/03-improve-gc-stats.patch"
    "${patchSet}/patches/ruby/2.1.0/railsexpress/04-display-more-detailed-stack-trace.patch"
    "${patchSet}/patches/ruby/2.1.0/railsexpress/05-show-full-backtrace-on-stack-overflow.patch"
    "${patchSet}/patches/ruby/2.1.0/railsexpress/06-fix-missing-c-return-event.patch"
    "${patchSet}/patches/ruby/2.1.0/railsexpress/07-backport-006e66b6680f60adfb434ee7397f0dbc77de7873.patch"
    "${patchSet}/patches/ruby/2.1.0/railsexpress/08-funny-falcon-stc-density.patch"
    "${patchSet}/patches/ruby/2.1.0/railsexpress/09-funny-falcon-stc-pool-allocation.patch"
    "${patchSet}/patches/ruby/2.1.0/railsexpress/10-aman-opt-aset-aref-str.patch"
    "${patchSet}/patches/ruby/2.1.0/railsexpress/11-funny-falcon-method-cache.patch"
    "${patchSet}/patches/ruby/2.1.0/railsexpress/12-backport-r44370.patch"
  ];
  "2.1.1" = [
    ./ssl_v3.patch
  ] ++ ops useRailsExpress [
    "${patchSet}/patches/ruby/2.1.0/railsexpress/01-zero-broken-tests.patch"
    "${patchSet}/patches/ruby/2.1.0/railsexpress/02-improve-gc-stats.patch"
    "${patchSet}/patches/ruby/2.1.0/railsexpress/03-display-more-detailed-stack-trace.patch"
    "${patchSet}/patches/ruby/2.1.0/railsexpress/04-show-full-backtrace-on-stack-overflow.patch"
    "${patchSet}/patches/ruby/2.1.0/railsexpress/05-fix-missing-c-return-event.patch"
    "${patchSet}/patches/ruby/2.1.0/railsexpress/07-backport-006e66b6680f60adfb434ee7397f0dbc77de7873.patch"
    "${patchSet}/patches/ruby/2.1.0/railsexpress/08-funny-falcon-stc-density.patch"
    "${patchSet}/patches/ruby/2.1.0/railsexpress/09-funny-falcon-stc-pool-allocation.patch"
    "${patchSet}/patches/ruby/2.1.0/railsexpress/10-aman-opt-aset-aref-str.patch"
    "${patchSet}/patches/ruby/2.1.0/railsexpress/11-funny-falcon-method-cache.patch"
    "${patchSet}/patches/ruby/2.1.0/railsexpress/12-backport-r44370.patch"
  ];
  "2.1.2" = [
    ./ssl_v3.patch
  ] ++ ops useRailsExpress [
    "${patchSet}/patches/ruby/2.1.2/railsexpress/01-zero-broken-tests.patch"
    "${patchSet}/patches/ruby/2.1.2/railsexpress/02-improve-gc-stats.patch"
    "${patchSet}/patches/ruby/2.1.2/railsexpress/03-display-more-detailed-stack-trace.patch"
    "${patchSet}/patches/ruby/2.1.2/railsexpress/04-show-full-backtrace-on-stack-overflow.patch"
    "${patchSet}/patches/ruby/2.1.2/railsexpress/05-fix-missing-c-return-event.patch"
    "${patchSet}/patches/ruby/2.1.2/railsexpress/06-backport-006e66b6680f60adfb434ee7397f0dbc77de7873.patch"
    "${patchSet}/patches/ruby/2.1.2/railsexpress/07-funny-falcon-stc-density.patch"
    "${patchSet}/patches/ruby/2.1.2/railsexpress/08-funny-falcon-stc-pool-allocation.patch"
    "${patchSet}/patches/ruby/2.1.2/railsexpress/09-aman-opt-aset-aref-str.patch"
    "${patchSet}/patches/ruby/2.1.2/railsexpress/10-funny-falcon-method-cache.patch"
  ];
  "2.1.3" = [
    ./ssl_v3.patch
  ] ++ ops useRailsExpress [
    "${patchSet}/patches/ruby/2.1.3/railsexpress/01-zero-broken-tests.patch"
    "${patchSet}/patches/ruby/2.1.3/railsexpress/02-improve-gc-stats.patch"
    "${patchSet}/patches/ruby/2.1.3/railsexpress/03-display-more-detailed-stack-trace.patch"
    "${patchSet}/patches/ruby/2.1.3/railsexpress/04-show-full-backtrace-on-stack-overflow.patch"
    "${patchSet}/patches/ruby/2.1.3/railsexpress/05-funny-falcon-stc-density.patch"
    "${patchSet}/patches/ruby/2.1.3/railsexpress/06-funny-falcon-stc-pool-allocation.patch"
    "${patchSet}/patches/ruby/2.1.3/railsexpress/07-aman-opt-aset-aref-str.patch"
    "${patchSet}/patches/ruby/2.1.3/railsexpress/08-funny-falcon-method-cache.patch"
  ];
  "2.1.6" = [
    ./ssl_v3.patch
  ] ++ ops useRailsExpress [
    "${patchSet}/patches/ruby/2.1.6/railsexpress/01-zero-broken-tests.patch"
    "${patchSet}/patches/ruby/2.1.6/railsexpress/02-improve-gc-stats.patch"
    "${patchSet}/patches/ruby/2.1.6/railsexpress/03-display-more-detailed-stack-trace.patch"
    "${patchSet}/patches/ruby/2.1.6/railsexpress/04-show-full-backtrace-on-stack-overflow.patch"
    "${patchSet}/patches/ruby/2.1.6/railsexpress/05-funny-falcon-stc-density.patch"
    "${patchSet}/patches/ruby/2.1.6/railsexpress/06-funny-falcon-stc-pool-allocation.patch"
    "${patchSet}/patches/ruby/2.1.6/railsexpress/07-aman-opt-aset-aref-str.patch"
    "${patchSet}/patches/ruby/2.1.6/railsexpress/08-funny-falcon-method-cache.patch"
    "${patchSet}/patches/ruby/2.1.6/railsexpress/09-heap-dump-support.patch"
  ];
  "2.1.7" = [
    ./ssl_v3.patch
  ] ++ ops useRailsExpress [
    "${patchSet}/patches/ruby/2.1.7/railsexpress/01-zero-broken-tests.patch"
    "${patchSet}/patches/ruby/2.1.7/railsexpress/02-improve-gc-stats.patch"
    "${patchSet}/patches/ruby/2.1.7/railsexpress/03-display-more-detailed-stack-trace.patch"
    "${patchSet}/patches/ruby/2.1.7/railsexpress/04-show-full-backtrace-on-stack-overflow.patch"
    "${patchSet}/patches/ruby/2.1.7/railsexpress/05-funny-falcon-stc-density.patch"
    "${patchSet}/patches/ruby/2.1.7/railsexpress/06-funny-falcon-stc-pool-allocation.patch"
    "${patchSet}/patches/ruby/2.1.7/railsexpress/07-aman-opt-aset-aref-str.patch"
    "${patchSet}/patches/ruby/2.1.7/railsexpress/08-funny-falcon-method-cache.patch"
    "${patchSet}/patches/ruby/2.1.7/railsexpress/09-heap-dump-support.patch"
  ];
  "2.2.0" = [
    ./ssl_v3.patch
  ] ++ ops useRailsExpress [
    "${patchSet}/patches/ruby/2.2.0/railsexpress/01-zero-broken-tests.patch"
    "${patchSet}/patches/ruby/2.2.0/railsexpress/02-improve-gc-stats.patch"
    "${patchSet}/patches/ruby/2.2.0/railsexpress/03-display-more-detailed-stack-trace.patch"
    "${patchSet}/patches/ruby/2.2.0/railsexpress/04-backport-401c8bb.patch"
    "${patchSet}/patches/ruby/2.2.0/railsexpress/05-fix-packed-bitfield-compat-warning-for-older-gccs.patch"
  ];
  "2.2.2" = [
    ./ssl_v3.patch
  ] ++ ops useRailsExpress [
    "${patchSet}/patches/ruby/2.2.2/railsexpress/01-zero-broken-tests.patch"
    "${patchSet}/patches/ruby/2.2.2/railsexpress/02-improve-gc-stats.patch"
    "${patchSet}/patches/ruby/2.2.2/railsexpress/03-display-more-detailed-stack-trace.patch"
    "${patchSet}/patches/ruby/2.2.2/railsexpress/04-backported-bugfixes-222.patch"
  ];
  "2.2.3" = [
    ./ssl_v3.patch
  ] ++ ops useRailsExpress [
    "${patchSet}/patches/ruby/2.2.3/railsexpress/01-zero-broken-tests.patch"
    "${patchSet}/patches/ruby/2.2.3/railsexpress/02-improve-gc-stats.patch"
    "${patchSet}/patches/ruby/2.2.3/railsexpress/03-display-more-detailed-stack-trace.patch"
  ];
  "2.3.0" = ops useRailsExpress [
    "${patchSet}/patches/ruby/2.3.0/railsexpress/01-skip-broken-tests.patch"
    "${patchSet}/patches/ruby/2.3.0/railsexpress/02-improve-gc-stats.patch"
    "${patchSet}/patches/ruby/2.3.0/railsexpress/03-display-more-detailed-stack-trace.patch"
  ];
}
