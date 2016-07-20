{ patchSet, useRailsExpress, ops, patchLevel }:

rec {
  "1.9.3" = [
    ./ssl_v3.patch
    ./rand-egd.patch
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
    ./rand-egd.patch
  ] ++ ops useRailsExpress [
    "${patchSet}/patches/ruby/2.0.0/p${patchLevel}/railsexpress/01-zero-broken-tests.patch"
    "${patchSet}/patches/ruby/2.0.0/p${patchLevel}/railsexpress/02-railsexpress-gc.patch"
    "${patchSet}/patches/ruby/2.0.0/p${patchLevel}/railsexpress/03-display-more-detailed-stack-trace.patch"
    "${patchSet}/patches/ruby/2.0.0/p${patchLevel}/railsexpress/04-show-full-backtrace-on-stack-overflow.patch"
  ];
  "2.1.7" = [
    ./ssl_v3.patch
    ./rand-egd.patch
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
  "2.2.3" = [
    ./ssl_v3.patch
    ./ruby22-rand-egd.patch
  ] ++ ops useRailsExpress [
    "${patchSet}/patches/ruby/2.2.3/railsexpress/01-zero-broken-tests.patch"
    "${patchSet}/patches/ruby/2.2.3/railsexpress/02-improve-gc-stats.patch"
    "${patchSet}/patches/ruby/2.2.3/railsexpress/03-display-more-detailed-stack-trace.patch"
  ];
  "2.3.1" = ops useRailsExpress [
    "${patchSet}/patches/ruby/2.3/head/railsexpress/01-skip-broken-tests.patch"
    "${patchSet}/patches/ruby/2.3/head/railsexpress/02-improve-gc-stats.patch"
    "${patchSet}/patches/ruby/2.3/head/railsexpress/03-display-more-detailed-stack-trace.patch"
  ];
}
