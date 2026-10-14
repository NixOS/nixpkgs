#include <nvtx3/nvToolsExt.h>

#include <stdio.h>

static int NVTX_API rangePushA(const char* message)
{
    printf("nvtxRangePushA: %s\n", message);
    return 0;
}

static int NVTX_API domainRangePushEx(nvtxDomainHandle_t domain, const nvtxEventAttributes_t* attributes)
{
    (void)domain;
    printf("nvtxDomainRangePushEx: %s\n", attributes->message.ascii);
    return 0;
}

static int setSlot(NvtxGetExportTableFunc_t getExportTable, NvtxCallbackModule module, unsigned int id,
                   NvtxFunctionPointer function)
{
    const NvtxExportTableCallbacks* callbacks =
        (const NvtxExportTableCallbacks*)getExportTable(NVTX_ETID_CALLBACKS);
    NvtxFunctionTable table = 0;
    unsigned int size = 0;
    if (!callbacks || !callbacks->GetModuleFunctionTable(module, &table, &size) || id >= size)
    {
        return 0;
    }
    *table[id] = function;
    return 1;
}

int NVTX_API InitializeInjectionNvtx2(NvtxGetExportTableFunc_t getExportTable)
{
    return setSlot(getExportTable, NVTX_CB_MODULE_CORE, NVTX_CBID_CORE_RangePushA, (NvtxFunctionPointer)rangePushA)
        && setSlot(getExportTable, NVTX_CB_MODULE_CORE2, NVTX_CBID_CORE2_DomainRangePushEx,
                   (NvtxFunctionPointer)domainRangePushEx);
}
